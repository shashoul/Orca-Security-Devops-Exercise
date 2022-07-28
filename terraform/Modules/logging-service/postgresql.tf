# generate postgresql database password.
resource "random_password" "postgresql_pass" {
  length           = 40
  special          = false
}

locals {
  db_pass = random_password.postgresql_pass.result
}

# database subnet group.
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.service_name}-db-subnet-group"
  subnet_ids = var.vpc.private_subnets

  tags = {
    Name = "${var.service_name}-db-subnet-group"
  }
}

# postgresql database (RDS)
resource "aws_db_instance" "db" {
  identifier           = var.service_name
  instance_class       = "db.t3.micro"
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "13.4"
  username             = var.db_username
  password             = local.db_pass
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  security_group_names = []
  publicly_accessible  = false
  skip_final_snapshot  = true
  db_name              = var.db_name

  tags = {
    Name = "${var.service_name}-database"
  }
}
