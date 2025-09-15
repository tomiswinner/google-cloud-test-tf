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


# VPC
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
# Subnet
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}


# タスク定義
## クラスターを跨いで使い回しできるリソース(クラスターにもサービスにも紐づかない)
## 
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "main" {
  family = "main"
  network_mode = "awsvpc" # bridge, none, host, awsvpc, 基本は　awsvpc でコンテナ単位で ENI を持たせる
  requires_compatibilities = ["FARGATE"] # EC2 or FARGATE
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn # ECS がタスクを起動するためのロール（ECR pull, Cw logs への権限とか）
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn # タスクが利用するロール = アプリケーション用のロール
  container_definitions = jsonencode([
    {
      name = "main"
      image = "nginx:latest"
    }
  ])
}


# クラスター
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "main" {
  name = "main"
}


# サービス
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "main" {
  name = "main"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count = 1
  network_configuration {
    subnets = [aws_subnet.main.id]
    security_groups = [aws_security_group.main.id]
  }
}
