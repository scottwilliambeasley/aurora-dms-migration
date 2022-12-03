// Terragrunt Git Locals File
//
//  This file should hold Git-specific variables intended to be used by any and all deployments irrespective of region or deployment environment.
//  Use this file to integrate Terraform with CI/CD by making shell variables and the results of commands into values Terragrunt knows about.
//
//  Fill the locals statement in this file with variables to be injected into your Terraform templates.
//  Once you've populated this file, reference it within a `locals` Terragrunt statement within a terragrunt.hcl file.
//  Once you've used this within a locals statement in a terragrunt.hcl file, you may then use the individual variables here as input variables to your Terraform modules and templates.

locals {
  git_branch = get_env("CI_COMMIT_BRANCH", run_cmd("git", "branch", "--show-current"))
}