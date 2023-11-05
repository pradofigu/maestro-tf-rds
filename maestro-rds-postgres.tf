resource "aws_security_group" "maestro_rds_sg" {
  name   = "maestro-rds-sg"
  vpc_id = "vpc-0207cbc8b0a47452b"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    bu = "maestro"
  }
}

resource "aws_db_parameter_group" "maestro" {
  name   = "maestro"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "maestro" {
  identifier             = "maestro"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  db_subnet_group_name   = "maestro-rds-sng"
  vpc_security_group_ids = [aws_security_group.maestro_rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.maestro.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}