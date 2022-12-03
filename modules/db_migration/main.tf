provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
}

#---------------------------------------------------------------------------
# Network
#---------------------------------------------------------------------------

data "aws_vpc" "pre_existing_vpc" {
 id = var.vpc_id  
}

data "aws_subnet" "subnet_a" {
  id = var.subnet_a_id
}

data "aws_subnet" "subnet_b" {
  id = var.subnet_b_id
}

#---------------------------------------------------------------------------
# Security Groups
#---------------------------------------------------------------------------

resource "aws_security_group" "dms_instance_sg" {
  description = "SG for your DMS instance."
  vpc_id      = data.aws_vpc.pre_existing_vpc.id

  # Allow all inbound traffic (tighten this after DMS replication finishes)
  ingress {
    description = "Allow all traffic incoming from subnets inside the VPC."
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description     = "Allow all outbound traffic."
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "aurora_sg" {
  description = "SG for Aurora cluster."
  vpc_id      = data.aws_vpc.pre_existing_vpc.id

  # Allow all inbound traffic (tighten this after DMS replication finishes)
  ingress {
    description = "Allow all traffic incoming from subnets inside the VPC."
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks     = [data.aws_vpc.pre_existing_vpc.cidr_block]
  }

  # Allow all outbound traffic from the cluster
  egress {
    description     = "Allow all outbound traffic."
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
  }

}


#---------------------------------------------------------------------------
# DMS Configuration
#---------------------------------------------------------------------------

module "dms" {
  source  = "terraform-aws-modules/dms/aws"
  version = "1.6.1"

# Subnet group
  repl_subnet_group_name        = "Replication-Subnet-Group"
  repl_subnet_group_description = "Replication Subnet Group"
  repl_subnet_group_subnet_ids  = [data.aws_subnet.subnet_a.id, data.aws_subnet.subnet_b.id]

# Replication Instance
  repl_instance_allocated_storage            = var.repl_instance_allocated_storage
  repl_instance_auto_minor_version_upgrade   = var.repl_instance_auto_minor_version_upgrade
  repl_instance_allow_major_version_upgrade  = var.repl_instance_allow_major_version_upgrade
  repl_instance_apply_immediately            = var.repl_instance_apply_immediately
  repl_instance_engine_version               = var.repl_instance_engine_version
  repl_instance_multi_az                     = var.repl_instance_multi_az
  repl_instance_preferred_maintenance_window = var.repl_instance_preferred_maintenance_window
  repl_instance_publicly_accessible          = var.repl_instance_publicly_accessible
  repl_instance_class                        = var.repl_instance_class
  repl_instance_id                           = var.repl_instance_id
  repl_instance_vpc_security_group_ids       = [aws_security_group.dms_instance_sg.id]

# Source and Destination Endpoints
  endpoints = {
    source = {
      database_name               = var.source_database_name
      endpoint_id                 = var.source_endpoint_id
      endpoint_type               = var.source_endpoint_type
      engine_name                 = var.source_engine_name
      extra_connection_attributes = var.source_extra_connection_attributes
      username                    = var.source_username
      password                    = var.source_password
      port                        = var.source_port
      server_name                 = var.source_server_name
      ssl_mode                    = var.source_ssl_mode
      tags                        = { EndpointType = "source" }
    }

    destination = {
      database_name = var.destination_database_name
      endpoint_id   = var.destination_endpoint_id
      endpoint_type = var.destination_endpoint_type
      engine_name   = var.destination_engine_name
      username      = var.destination_username
      password      = var.destination_password
      port          = var.destination_port
      server_name   = var.destination_server_name
      ssl_mode      = var.destination_ssl_mode
      tags          = { EndpointType = "destination" }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment_name
  }

}

#---------------------------------------------------------------------------
# Aurora Configuration
#---------------------------------------------------------------------------

module "aurora_cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name           = "destination-aurora-db"
  engine         = var.aurora_engine
  engine_version = var.aurora_engine_version
  instance_class = var.aurora_instance_class
  instances = {
    one = {}
    2 = {
      instance_class = "db.r6g.2xlarge"
    }
  }

  vpc_id  = data.aws_vpc.pre_existing_vpc.id
  subnets = [data.aws_subnet.subnet_a.id, data.aws_subnet.subnet_b.id]

  allowed_security_groups = [aws_security_group.aurora_sg.id]
  allowed_cidr_blocks     = [data.aws_vpc.pre_existing_vpc.cidr_block]

  storage_encrypted   = var.storage_encrypted
  apply_immediately   = true
  monitoring_interval = var.monitoring_interval

  db_parameter_group_name         = aws_db_parameter_group.default.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.default.name

  enabled_cloudwatch_logs_exports = ["general"]

  tags = {
    Environment = var.environment_name
    Terraform   = "true"
  }

}

resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "aurora-mysql5.7"

  parameter {
    name  = "aurora_parallel_query"
    value = "ON"
  }

}

resource "aws_rds_cluster_parameter_group" "default" {
  name        = "rds-cluster-sql"
  family      = "aurora-mysql5.7"
  description = "RDS default cluster parameter group"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}