output "front_repository_url" {
  value = aws_ecr_repository.front.repository_url
}

output "back_repository_url" {
  value = aws_ecr_repository.back.repository_url
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "front_alb_url" {
  value = "http://${aws_lb.main.dns_name}"
}

output "back_alb_url" {
  value = "http://${aws_lb.main.dns_name}:8080"
}
