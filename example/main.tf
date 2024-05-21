################################################################
## defaults
################################################################
terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }

  // backend "s3" {}

}

provider "aws" {
  region = var.region
}


module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.5"
  environment = "dev"
  project     = "arc"
}


################################################################################
## AWS backup
################################################################################
module "backup" {
  source                   = "../"
  backup_vault_data        = local.backup_vault_data
  backup_plan              = local.backup_plan
  create_role              = true
  role_name                = local.backup_role_name
  backup_selection_data    = local.backup_selection_data
  vault_lock_configuration = local.vault_lock_configuration

  tags = module.tags.tags
}
