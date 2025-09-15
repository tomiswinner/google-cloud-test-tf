

resource "aws_ecs_cluster" "main" {
  name = "main"
}

resource "aws_ecs_task_definition" "main" {
  family = "main"
  container_definitions = jsonencode([
    {
      name = "main"
      image = "nginx:latest"
    }
  ])
}
