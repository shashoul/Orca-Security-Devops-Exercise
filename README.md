# Orca-Security-Devops-Exercise

## Introduction

This repo will deploy a python service(logging) that logs unique access to the service under AWS account using Terraform,
that will provisioing the following AWS resources:
- AWS ECR
- AWS VPC
- AWS VPC connector
- AWS RDS (postgresql)
- AWS App Runner

AWS App Runner is an AWS service that provides a fast, simple, and cost-effective way to deploy from source code or a container image directly to a scalable and secure web application in the AWS Cloud. [https://aws.amazon.com/apprunner/] (other option that has been consider is Beanstalk).


## Deployment
 1. Terraform will first build the project VPC and VPC connector for network connection with AWS App Runner and ECR repository. 
 2. will build the project docker image and push it to ECR repo.
 3. and then will build the endpoint service (AWS App Runner) and Postgresql (RDS) (as requested copies.)


## Build and Deploy
```bash
cd terraform
```

in variables.tf set VPC cidr address and services names as much copies you want to create:
```
variable "vpc_cidr" {
  description = "AWS VPC cidr address."
  default     = "10.0.0.0/16"
}

# the following will create one copy of the service called (logging-service)
variable "logging_services" {
  description = "list of Logging application services names to be created."
  default = [
    "logging-service"
  ]
}

```

```bash
terraform init 
terraform plan
terraform apply
terrform output (to see service url endpoint.)
```

an Example of terraform output:
```
ecr_repository = "904627253972.dkr.ecr.eu-west-1.amazonaws.com/logging-service"
services_url = {
  "logging-service" = "dugtr3ggev.eu-west-1.awsapprunner.com"   <- service url
}
```

![output](output.png)

## Architecture
![Architecture](application.png)