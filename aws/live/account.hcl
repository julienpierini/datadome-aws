# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "sandbox"
  aws_account_id = get_env("TF_VAR_aws_account_id", "000000000000")
}
