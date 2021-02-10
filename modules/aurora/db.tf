resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "wordpress subnet group"
  }
}

data "aws_secretsmanager_secret_version" "aurora_master" {
  secret_id = "prod/wordpress/aurora/master"
}

locals {
  aurora_db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.aurora_master.secret_string
  )
}

resource "aws_security_group" "mysql" {
  name        = "allow_mysql"
  description = "Allow mysql inbound traffic from private subnets"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allow_inbound_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mysql"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "wordpress"
  db_subnet_group_name    = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids  = [aws_security_group.mysql.id]
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.2"
  availability_zones      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  database_name           = "wordpress"
  master_username         = local.aurora_db_creds.username
  master_password         = local.aurora_db_creds.password
  backup_retention_period = 5
  preferred_backup_window = "02:00-04:00"
}

resource "aws_rds_cluster_instance" "wordpress_instances" {
  count              = 2
  identifier         = "wordpress-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.r4.large"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version
}
