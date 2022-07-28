
## Build application docker image and push it to ecr repo.
resource "null_resource" "logging-service" {

  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "../application/**") : filesha1(f)]))
  }

  provisioner "local-exec" {
    command     = <<EOT
      cd ../application
    	docker build -t logging-service . 
    	docker tag logging-service:latest ${data.aws_ecr_repository.image_repo.repository_url}:latest
    	aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${split("/", data.aws_ecr_repository.image_repo.repository_url)[0]}
    	docker push ${data.aws_ecr_repository.image_repo.repository_url}:latest
      EOT
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
  depends_on = [aws_ecr_repository.image_repo]
}


## Provisioning logging-services as requested.
module "logging-service" {
  source = "./Modules/logging-service"

  for_each           = toset(var.logging_services)
  service_name       = each.key
  vpc                = module.vpc
  vpc_connector_arn  = aws_apprunner_vpc_connector.connector.arn
  ecr_repository_url = data.aws_ecr_repository.image_repo.repository_url

  depends_on = [
    null_resource.logging-service,
    module.vpc
  ]
}