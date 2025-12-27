resource "aws_ecr_repository" "front" {
  name                 = "${var.project}-front"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "back" {
  name                 = "${var.project}-back"
  image_tag_mutability = "MUTABLE"
}
