locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.environment

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id   = local.account_vars.locals.aws_account_id

  # Automatically load project-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project      = local.project_vars.locals.project

  # Variables
  stack       = "iam"
  name_suffix = "${local.project}-${local.env}"

  # Terraform source
  module_version = "v0.1.0"

  # Tags
  tags = {
    Environment = local.env
    Project     = local.project
    Stack       = local.stack
    Deployer    = "terraform"
  }
}

terraform {
  source = "git@github.com:yukihira1992/terraform-aws-iam-service-role.git?ref=${local.module_version}"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  name        = "${local.name_suffix}-AppRunnerECRAccessRole"
  description = "IAM service role for build.apprunner.amazonaws.com with permissions to perform actions on ECR resources"

  service_ids = [
    "build.apprunner.amazonaws.com"
  ]
  iam_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
  ]

  tags = local.tags
}
