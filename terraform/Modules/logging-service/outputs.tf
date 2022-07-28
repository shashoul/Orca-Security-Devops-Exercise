output "postgresql_hostname" {
  description = "Postgresql RDS instance hostname"
  value       = aws_db_instance.db.address
  sensitive   = true
}

output "service_url" {
  value = aws_apprunner_service.logging-service.service_url
}