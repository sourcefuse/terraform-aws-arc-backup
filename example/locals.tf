locals {
  prefix = "arc-dev"

  backup_plan_name = "${local.prefix}-backup-plan"
  backup_role_name = "${local.prefix}-backup-restore"
  vault_name       = "${local.prefix}-backup-vault"
  dr_vault_name    = "${local.prefix}-backup-vault-dr"

  backup_vault_data = {
    name                            = local.vault_name
    enable_encryption               = true
    backup_role_name                = local.backup_role_name
    kms_key_deletion_window_in_days = 7
    kms_key_admin_arns              = []
  }

  dr_backup_vault_data = {
    name                            = local.dr_vault_name
    enable_encryption               = true
    backup_role_name                = local.backup_role_name
    kms_key_deletion_window_in_days = 7
    kms_key_admin_arns              = []
  }


  backup_plan = {
    name = local.backup_plan_name

    rules = [{
      name                     = "backup-rule-1"
      target_vault_name        = local.vault_name
      schedule                 = "cron(0 12 * * ? *)"
      recovery_point_tags      = module.tags.tags
      enable_continuous_backup = true

      lifecycle = [{ // its mandatory if `enable_continuous_backup = true` , error: Lifecycle must be specified for backup rule enabled continuous backup
        cold_storage_after = 0
        delete_after       = 35
      }]
    }]
  }

  backup_selection_data = {
    name      = "${local.prefix}-backup-selection"
    plan_name = local.backup_plan_name
    resources = ["*"]
    selection_tags = [{
      type  = "string"
      key   = "enable_backup"
      value = "true"
      }
    ]
  }

  vault_lock_configuration = {
    vault_name          = local.vault_name
    changeable_for_days = 3 // it has to be atleast 3
    max_retention_days  = 2
    min_retention_days  = 1
  }

  dr_vault_lock_configuration = {
    vault_name          = local.dr_vault_name
    changeable_for_days = 3 // it has to be atleast 3
    max_retention_days  = 2
    min_retention_days  = 1
  }

}
