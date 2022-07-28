## Create ecr repository for docker image.

resource "aws_ecr_repository" "image_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}



data "aws_ecr_repository" "image_repo" {
  name = var.ecr_repo_name

  depends_on = [
    aws_ecr_repository.image_repo
  ]
}