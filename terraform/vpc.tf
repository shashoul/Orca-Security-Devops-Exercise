## Create VPC and VPC connector for Aws App Runner.

data "aws_availability_zones" "available" {}

locals {
  private_subnet_cidr = [
    for index, val in data.aws_availability_zones.available.names :
    cidrsubnet(var.vpc_cidr, 8, index)
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name                 = "logging-service"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = local.private_subnet_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

## App Runner vpc connector.
resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "logging-service-vpc-connector"
  subnets            = module.vpc.private_subnets
  security_groups    = [module.vpc.default_security_group_id]
}