variable "aws_region" {
  default = "eu-west-1"
}

variable "db_name" {
  description = "Postgresql database name."
  default     = "logging"
}

variable "db_username" {
  description = "Postgresql database username."
  default     = "logging"
}

variable "service_name" {
  description = "Application logging service name."
}

variable "vpc" {
  description = "VPC data."
}


## App Runner auto scaling config.
variable "max_concurrency" {
  description = "AppRunner Instance MAX Concurrency"
  default     = 100
}

variable "max_size" {
  description = "AppRunner Instance MAX Size"
  default     = "10"
}

variable "min_size" {
  description = "AppRunner Instance MIN Size"
  default     = "2"
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 5000
}

variable "ecr_repository_url" {
  description = "ecr repository url contains the docker image."
}

variable "vpc_connector_arn" {
  description = "Aws vpc connector arn for network egress configuration."
}