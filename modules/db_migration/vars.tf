# variables.tf

variable "environment_name" {
  description = "name of environment being deployed into"
  default = "none"
}

#---------------------------------------------------------------------------
# Provider Setup
#---------------------------------------------------------------------------
variable "aws_region" {
  description = "AWS Region used to deploy AWS resources."
  default     = "us-east-2"
}

variable "aws_access_key" {
  description = "AWS access key used to identify the account."
  default     = ""
}

#---------------------------------------------------------------------------
# Network
#---------------------------------------------------------------------------

variable "vpc_id" {
  description = "ID of existing VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_a_id" {
  description = "ID of existing primary subnet used for replication instance subnet group."
}

variable "subnet_b_id" {
  description = "ID of existing secondary subnet used for replication instance subnet group."
}

#---------------------------------------------------------------------------
# Replication Instance Settings
#---------------------------------------------------------------------------

variable "repl_instance_allocated_storage" {
  description = ""
}

variable "repl_instance_auto_minor_version_upgrade" {
  description = ""
}

variable "repl_instance_allow_major_version_upgrade" {
  description = ""
}

variable "repl_instance_apply_immediately" {
  description = ""
}

variable "repl_instance_engine_version" {
  description = ""
}

variable "repl_instance_multi_az" {
  description = ""
}

variable "repl_instance_preferred_maintenance_window" {
  description = ""
}

variable "repl_instance_publicly_accessible" {
  description = ""
}

variable "repl_instance_class" {
  description = ""
}

variable "repl_instance_id" {
  description = ""
}

variable "repl_instance_vpc_security_group_ids" {
  description = ""
}

#---------------------------------------------------------------------------
# Source Endpoint Settings
#---------------------------------------------------------------------------
variable "source_database_name" {
  description = ""
}

variable "source_endpoint_id" {
  description = ""
}

variable "source_endpoint_type" {
  description = ""
}

variable "source_engine_name" {
  description = ""
}

variable "source_extra_connection_attributes" {
  description = ""
}

variable "source_username" {
  description = ""
}

variable "source_password" {
  description = ""
}

variable "source_port" {
  description = ""
}

variable "source_server_name" {
  description = ""
}

variable "source_ssl_mode" {
  description = ""
}

#---------------------------------------------------------------------------
# Destination Endpoint Settings
#---------------------------------------------------------------------------
variable "destination_database_name" {
  description = ""
}

variable "destination_endpoint_id" {
  description = ""
}

variable "destination_endpoint_type" {
  description = ""
}

variable "destination_engine_name" {
  description = ""
}

variable "destination_username" {
  description = ""
}

variable "destination_password" {
  description = ""
}

variable "destination_port" {
  description = ""
}

variable "destination_server_name" {
  description = ""
}

variable "destination_ssl_mode" {
  description = ""
}

#---------------------------------------------------------------------------
# Aurora DB Settings
#---------------------------------------------------------------------------

variable "aurora_engine" {
   description = "" 
}

variable "aurora_engine_version" {
   description = "" 
}

variable "aurora_instance_class" {
   description = "" 
}

variable storage_encrypted {
   description = "" 
}

variable monitoring_interval {
   description = "" 
}
