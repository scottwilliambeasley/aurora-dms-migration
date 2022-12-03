locals {
  region_vars               = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars          = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  git_vars                  = read_terragrunt_config(find_in_parent_folders("git.hcl"))
  common_vars               = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  aws_region                = local.region_vars.locals.aws_region
  state_bucket              = local.environment_vars.locals.state_bucket
  state_table               = "TerraformStateLockTable"
}

### Uncomment to store remote state in S3 for CI/CD
# # Remote state stored in Amazon S3
# remote_state {
#   backend = "s3"
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
#   config = {
#     bucket         = local.state_bucket
#     key            = "${path_relative_to_include()}/${local.git_vars.locals.git_branch}/terraform.tfstate"
#     region         = local.aws_region
#     encrypt        = true
#     dynamodb_table = local.state_table
#   }  
# }