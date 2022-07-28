variable "aws_region" {
  description = "AWS region."
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "AWS VPC cidr address."
  default     = "10.0.0.0/16"
}

variable "ecr_repo_name" {
  description = "AWS ecr repo name."
  default     = "logging-service"
}

variable "logging_services" {
  description = "list of Logging application services names to be created."
  default = [
    "logging-service"
  ]
}