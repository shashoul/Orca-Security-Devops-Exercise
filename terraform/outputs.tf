
output "ecr_repository" {
  value = data.aws_ecr_repository.image_repo.repository_url
}

## Print logging services URLs.
output "services_url" {
  value = {
    for service in toset(var.logging_services) :
    service => module.logging-service[service].service_url
  }
}