resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster"
}

resource "aws_ecs_task_definition" "front" {
  family                   = "${var.project}-front"
  cpu                      = var.front_cpu
  memory                   = var.front_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions    = jsonencode([
    {
      name      = "front"
      image     = "${aws_ecr_repository.front.repository_url}:latest"
      essential = true
      portMappings = [ { containerPort = 3000, protocol = "tcp" } ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-front"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "back" {
  family                   = "${var.project}-back"
  cpu                      = var.back_cpu
  memory                   = var.back_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions    = jsonencode([
    {
      name      = "back"
      image     = "${aws_ecr_repository.back.repository_url}:latest"
      essential = true
      portMappings = [ { containerPort = 8080, protocol = "tcp" } ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-back"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "front" {
  name              = "/ecs/${var.project}-front"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "back" {
  name              = "/ecs/${var.project}-back"
  retention_in_days = 7
}

resource "aws_ecs_service" "front" {
  name            = "${var.project}-front-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.front.arn
  desired_count   = var.front_desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.front.arn
    container_name   = "front"
    container_port   = 3000
  }
  depends_on = [aws_lb_listener.front]
}

resource "aws_ecs_service" "back" {
  name            = "${var.project}-back-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.back.arn
  desired_count   = var.back_desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.back.arn
    container_name   = "back"
    container_port   = 8080
  }
  depends_on = [aws_lb_listener.back]
}
