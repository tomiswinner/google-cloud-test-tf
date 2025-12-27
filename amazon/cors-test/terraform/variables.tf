variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-northeast-1"
}

variable "project" {
  type    = string
  default = "tak-cors-test"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "front_desired_count" {
  type    = number
  default = 1
}

variable "back_desired_count" {
  type    = number
  default = 1
}

variable "front_cpu" {
  type    = string
  default = "256"
}

variable "front_memory" {
  type    = string
  default = "512"
}

variable "back_cpu" {
  type    = string
  default = "256"
}

variable "back_memory" {
  type    = string
  default = "512"
}
