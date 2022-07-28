
resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}

## App Runner IAM Role.
resource "aws_iam_role" "apprunner-service-role" {
  name               = "${var.service_name}-AppRunnerECRAccessRole-${random_string.random.result}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.apprunner-service-assume-policy.json
}

data "aws_iam_policy_document" "apprunner-service-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "apprunner-service-role-attachment" {
  role       = aws_iam_role.apprunner-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}


## App Runner Auto Scaling Config.
resource "aws_apprunner_auto_scaling_configuration_version" "auto-scaling-config" {
  auto_scaling_configuration_name = "auto-scaling-${random_string.random.result}"
  max_concurrency                 = var.max_concurrency
  max_size                        = var.max_size
  min_size                        = var.min_size

  tags = {
    Name = "${var.service_name}-auto-scaling-config-${random_string.random.result}"
  }
}


## App Runner service.
resource "aws_apprunner_service" "logging-service" {
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.auto-scaling-config.arn
  service_name                   = "${var.service_name}-${random_string.random.result}"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner-service-role.arn
    }
    image_repository {
      image_configuration {
        port = var.container_port
        runtime_environment_variables = {
          "AWS_REGION" : "${var.aws_region}",
          "DATABASE_URL" : "postgresql://${var.db_username}:${local.db_pass}@${aws_db_instance.db.address}/${var.db_name}"
        }
      }
      image_identifier      = "${var.ecr_repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = var.vpc_connector_arn
    }
  }

  depends_on = [aws_iam_role.apprunner-service-role, aws_db_instance.db, aws_iam_role_policy_attachment.apprunner-service-role-attachment]
}