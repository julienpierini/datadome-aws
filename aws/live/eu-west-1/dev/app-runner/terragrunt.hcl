locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.environment

  # Automatically load vpc variables
  app_runner_vars                  = read_terragrunt_config(find_in_parent_folders("vars/app-runner.hcl"))
  httpapp_cpu                      = local.app_runner_vars.locals.httpapp_cpu
  httpapp_enabled_auto_deployments = local.app_runner_vars.locals.httpapp_enabled_auto_deployments
  httpapp_image_version            = local.app_runner_vars.locals.httpapp_image_version
  httpapp_max_concurrency          = local.app_runner_vars.locals.httpapp_max_concurrency
  httpapp_max_size                 = local.app_runner_vars.locals.httpapp_max_size
  httpapp_memory                   = local.app_runner_vars.locals.httpapp_memory
  httpapp_min_size                 = local.app_runner_vars.locals.httpapp_min_size
  httpapp_port                     = local.app_runner_vars.locals.httpapp_port

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
  stack       = "app-runner"
  name_suffix = "${local.project}-${local.env}"

  # Terraform source
  module_version = "v0.1.1"

  # Tags
  tags = {
    Environment = local.env
    Project     = local.project
    stack       = local.stack
    Deployer    = "terraform"
  }
}

terraform {
  source = "git@github.com:julienpierini/terraform-aws-app-runner.git?ref=${local.module_version}"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "ecr" {
  config_path = "../ecr"
}

dependency "kms" {
  config_path = "../kms"
}

dependency "iam" {
  config_path = "../iam"
}

dependencies {
  paths = ["../ecr", "../kms", "../iam"]
}

inputs = {

  name_suffix             = "${local.stack}-${local.name_suffix}"
  service_linked_role_arn = dependency.iam.outputs.arn

  app_runner = {
    "httpapp" = {
      enable_vpc_egress_configuration = false
      enabled_auto_deployments        = local.httpapp_enabled_auto_deployments
      kms_key_arn                     = dependency.kms.outputs.key_arn

      image_repository_type = "ECR"
      image_identifier      = "${dependency.ecr.outputs.repository_url}:${local.httpapp_image_version}"

      auto_scaling_configuration = {
        max_concurrency = local.httpapp_max_concurrency
        max_size        = local.httpapp_max_size
        min_size        = local.httpapp_min_size
        tags            = local.tags
      }
      image_configuration = {
        port = local.httpapp_port
      }
      instance_configuration = {
        cpu    = local.httpapp_cpu
        memory = local.httpapp_memory
      }

      tags = local.tags
    }
  }

}
