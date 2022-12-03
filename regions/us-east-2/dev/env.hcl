// Terragrunt Environment Locals File
//
//  This file should hold variables specific to the tier of your environment inside a specific AWS region e.g. the 'dev' environment in 'us-east-2'.
//
//  Fill the locals statement in this file with variables to be injected into your Terraform templates.
//  Once you've populated this file, reference it within a `locals` Terragrunt statement within a terragrunt.hcl file.
//  Once you've used this within a locals statement in a terragrunt.hcl file, you may then use the individual variables here as input variables to your Terraform modules and templates.

locals {

// Environment name
  environment_name = "dev"

// Base Network Infrastructure
  vpc_id      = "vpc-0ed84f961864d2ad3"
  subnet_a_id = "subnet-01a6fc7b5a86617a7"
  subnet_b_id = "subnet-06f93009c7b925a26"

// DMS Configurations

  // Replication Instance Settings
  repl_instance_allocated_storage            = 64
  repl_instance_auto_minor_version_upgrade   = true
  repl_instance_allow_major_version_upgrade  = true
  repl_instance_apply_immediately            = true
  repl_instance_engine_version               = "3.4.5"
  repl_instance_multi_az                     = true
  repl_instance_preferred_maintenance_window = "sun:10:30-sun:14:30"
  repl_instance_publicly_accessible          = false
  repl_instance_class                        = "dms.t3.medium"
  repl_instance_id                           = "dms-instance"
  repl_instance_vpc_security_group_ids       = ["sg-12345678"]

  // Source Endpoint Settings
  source_database_name               = "example"
  source_endpoint_id                 = "source-endpoint"
  source_endpoint_type               = "source"
  source_engine_name                 = "aurora-postgresql"
  source_extra_connection_attributes = "heartbeatFrequency=1;"
  source_username                    = "postgresqlUser"
  source_password                    = "youShouldPickABetterPassword123!"
  source_port                        = 5432
  source_server_name                 = "dms-ex-src.cluster-abcdefghijkl.us-east-1.rds.amazonaws.com"
  source_ssl_mode                    = "none"

  // Destination Endpoint Settings
  destination_database_name = "example"
  destination_endpoint_id   = "destination-endpoint"
  destination_endpoint_type = "target"
  destination_engine_name   = "aurora"
  destination_username      = "mysqlUser"
  destination_password      = "passwordsDoNotNeedToMatch789?"
  destination_port          = 3306
  destination_server_name   = "dms-ex-dest.cluster-abcdefghijkl.us-east-1.rds.amazonaws.com"
  destination_ssl_mode      = "none"

  // S3 Bucket used for remote state (only used if enabled within top level terragrunt.hcl)
  state_bucket = "name-of-state-bucket"


}