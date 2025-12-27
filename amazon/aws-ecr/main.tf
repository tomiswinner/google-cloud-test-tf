

# ECR
data "aws_ecr_repository" "frontend" {
  name = "frontend"
}


# IAM for ECS Task Execution Role : ECS がタスクを起動するためのロール（ECR pull, Cw logs への権限とか）
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role" "ecs_task_execution_role" {

  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid = "ECSRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role_policy.arn
}

# IAM for ECS Task Role : Task 自身が利用するロール
data "aws_iam_policy" "ecs_task_role_policy" {
  name = "AdministratorAccess"
}
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid = "ECSTaskRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = data.aws_iam_policy.ecs_task_role_policy.arn
}


# VPC 関連
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
## 本体
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ecs-vpc"
  }
}
## Route Table
### デフォルト
data "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}
### ルート追加
resource "aws_route" "main_internet" {
  route_table_id = data.aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

# Internet Gateway
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ecs-igw"
  }
}


# Subnet
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "alb_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "ecs-subnet-alb-1"
  }
}
resource "aws_subnet" "alb_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "ecs-subnet-alb-2"
  }
}
resource "aws_subnet" "fargate_frontend_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "ecs-subnet-fargate-frontend-1"
  }
}

resource "aws_subnet" "fargate_backend_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "ecs-subnet-fargate-backend-1"
  }
}



# Security Group for ECS
resource "aws_security_group" "sg_ecs" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.sg_alb.id]
  }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [var.MY_IP]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Security Group for ALB
## CloudFront origin-facing PrefixList : https://dev.classmethod.jp/articles/terraform-cloudfromt-managed-prefix-list/
data "aws_ec2_managed_prefix_list" "attribute" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}
## 本体
resource "aws_security_group" "sg_alb" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.attribute.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# CloudWatch Logs
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/frontend"
  retention_in_days = 30
}

# タスク定義
## クラスターを跨いで使い回しできるリソース(クラスターにもサービスにも紐づかない)
## 
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "main" {
  family = "frontend"
  network_mode = "awsvpc" # bridge, none, host, awsvpc, 基本は　awsvpc でコンテナ単位で ENI を持たせる
  requires_compatibilities = ["FARGATE"] # EC2 or FARGATE
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn # ECS がタスクを起動するためのロール（ECR pull, Cw logs への権限とか）
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn # タスクが利用するロール = アプリケーション用のロール
  runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture = "ARM64"
  }
  container_definitions = jsonencode([
    {
      name = "main"
      image = "${data.aws_ecr_repository.frontend.repository_url}:latest"
      memory = 512
      cpu = 256
      portMappings = [
        {
          containerPort = 3000
          hostPort = 3000
        }
      ]
      environment = [
        {
          name = "NODE_ENV"
          value = "production"
        },
        # ECS が HOSTNAME を上書きするので、0.0.0.0 にこちらで上書きしておいてやる必要がある
        # https://github.com/vercel/next.js/issues/58657
        {
          name = "HOSTNAME"
          value = "0.0.0.0"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/frontend"
          awslogs-region = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


# クラスター
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "main" {
  name = "main"
}


# サービス
## フロントエンド
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "frontend" {
  name = "frontend"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count = 1
  network_configuration {
    subnets = [aws_subnet.fargate_frontend_1.id]
    security_groups = [aws_security_group.sg_ecs.id]
    assign_public_ip = true # fargate 限定、public ip を eni に付与する
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 1
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name = "main"
    container_port = 3000
  }
}
## バックエンド
### サービスがスケールの単位ではあるので、分けるのが定石
resource "aws_ecs_service" "backend" {
  name = "backend"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count = 1
  network_configuration {
    subnets = [aws_subnet.fargate_backend_1.id]
    security_groups = [aws_security_group.sg_ecs.id]
    assign_public_ip = true # fargate 限定、public ip を eni に付与する
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 1
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name = "main"
    container_port = 3000
  }
}


# ALB
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb
resource "aws_alb" "main" {
  name = "main"
  subnets = [aws_subnet.alb_1.id, aws_subnet.alb_2.id]
  security_groups = [aws_security_group.sg_alb.id]
  enable_deletion_protection = false
  tags = {
    Name = "ecs-alb"
  }
}

# target group
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group
resource "aws_lb_target_group" "frontend" {
  name        = "frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"   # Fargate は "ip" 必須, fargate は alb を紐付けておくと fargate が勝手に tg に対して register API を叩いて登録してくれ
  vpc_id      = aws_vpc.main.id
  health_check {
    path = "/"
    port = 3000
    matcher = "200-399"
    timeout = 10
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

# CloudFront 関連
## マネージド Cache Policy: CachingDisabled を名前で取得
data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}
# マネージド Origin Request Policy: AllViewer
data "aws_cloudfront_origin_request_policy" "all_viewer" {
  name = "Managed-AllViewer" # 全てのリクエストヘッダーを Origin に転送
}

## 本体
resource "aws_cloudfront_distribution" "main" {
  enabled = true
  # aliases = ["www.example.com"]  # 独自ドメイン用 CNAME
  default_cache_behavior {
    target_origin_id = aws_alb.main.id
    viewer_protocol_policy = "redirect-to-https" # https 強制
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    smooth_streaming = false
    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer.id
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  origin {
    domain_name = aws_alb.main.dns_name
    origin_id = aws_alb.main.id
    custom_origin_config { # ここないと、s3 defalut 解釈されそう？
      origin_protocol_policy = "http-only" # ALBへの通信をhttpにする場合
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
}
