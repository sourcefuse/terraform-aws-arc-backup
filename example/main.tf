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

provider "aws" {
  region = "us-east-2"
  alias  = "backup"
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
# (optional) Backup vault to store backups in another region
module "dr_backup_vault" {
  source                   = "../"
  backup_vault_data        = local.dr_backup_vault_data
  create_role              = true
  role_name                = local.backup_role_name
  vault_lock_configuration = local.dr_vault_lock_configuration

  tags = module.tags.tags

  providers = {
    aws = aws.backup
  }
}

# Backup vault to store backups in another region
module "backup" {
  source                   = "../"
  backup_vault_data        = local.backup_vault_data
  backup_plan              = local.backup_plan
  create_role              = false // Note :- Role is created in above module
  role_name                = module.dr_backup_vault.backup_role_name
  backup_selection_data    = local.backup_selection_data
  vault_lock_configuration = local.vault_lock_configuration

  tags = module.tags.tags

  depends_on = [module.dr_backup_vault]
}
