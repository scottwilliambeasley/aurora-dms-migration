// Terragrunt Region Locals File
//
//  This file should hold variables intended to be used by any and all deployments that hold the same AWS region e.g. 'us-east-2'.
//
//  Fill the locals statement in this file with variables to be injected into your Terraform templates.
//  Once you've populated this file, reference it within a `locals` Terragrunt statement within a terragrunt.hcl file.
//  Once you've used this within a locals statement in a terragrunt.hcl file, you may then use the individual variables here as input variables to your Terraform modules and templates.

locals {
  aws_region = "us-east-2"
}