// read variables across the regional, environmental, git specific, and universal configuration files
locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  git_vars         = read_terragrunt_config(find_in_parent_folders("git.hcl"))
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

// Use the db_migration module to establish infra
terraform {
  source = "../../../../modules//db_migration"
}

include {
  path = find_in_parent_folders()
}

// inputs
inputs = {
  region      = local.region_vars.locals.aws_region

  // DMS Configurations
  vpc_id      = local.environment_vars.locals.vpc_id
  subnet_a_id = local.environment_vars.locals.subnet_a_id
  subnet_b_id = local.environment_vars.locals.subnet_b_id

  // Replication Instance Settings
  repl_instance_allocated_storage            = local.environment_vars.locals.repl_instance_allocated_storage
  repl_instance_auto_minor_version_upgrade   = local.environment_vars.locals.repl_instance_auto_minor_version_upgrade
  repl_instance_allow_major_version_upgrade  = local.environment_vars.locals.repl_instance_allow_major_version_upgrade
  repl_instance_apply_immediately            = local.environment_vars.locals.repl_instance_apply_immediately
  repl_instance_engine_version               = local.environment_vars.locals.repl_instance_engine_version
  repl_instance_multi_az                     = local.environment_vars.locals.repl_instance_multi_az
  repl_instance_preferred_maintenance_window = local.environment_vars.locals.repl_instance_preferred_maintenance_window
  repl_instance_publicly_accessible          = local.environment_vars.locals.repl_instance_publicly_accessible
  repl_instance_class                        = local.environment_vars.locals.repl_instance_class
  repl_instance_id                           = local.environment_vars.locals.repl_instance_id
  repl_instance_vpc_security_group_ids       = local.environment_vars.locals.repl_instance_vpc_security_group_ids

  // Source Endpoint Settings
  source_database_name               = local.environment_vars.locals.source_database_name
  source_endpoint_id                 = local.environment_vars.locals.source_endpoint_id
  source_endpoint_type               = local.environment_vars.locals.source_endpoint_type
  source_engine_name                 = local.environment_vars.locals.source_engine_name
  source_extra_connection_attributes = local.environment_vars.locals.source_extra_connection_attributes
  source_username                    = local.environment_vars.locals.source_username
  source_password                    = local.environment_vars.locals.source_password
  source_port                        = local.environment_vars.locals.source_port
  source_server_name                 = local.environment_vars.locals.source_server_name
  source_ssl_mode                    = local.environment_vars.locals.source_ssl_mode

  // Destination Endpoint Settings
  destination_database_name = local.environment_vars.locals.destination_database_name
  destination_endpoint_id   = local.environment_vars.locals.destination_endpoint_id
  destination_endpoint_type = local.environment_vars.locals.destination_endpoint_type
  destination_engine_name   = local.environment_vars.locals.destination_engine_name
  destination_username      = local.environment_vars.locals.destination_username
  destination_password      = local.environment_vars.locals.destination_password
  destination_port          = local.environment_vars.locals.destination_port
  destination_server_name   = local.environment_vars.locals.destination_server_name
  destination_ssl_mode      = local.environment_vars.locals.destination_ssl_mode

}
