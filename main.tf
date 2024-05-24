# Backup plan
resource "aws_backup_plan" "this" {
  count = var.backup_plan == null ? 0 : 1

  name = var.backup_plan.name

  dynamic "rule" {
    for_each = var.backup_plan.rules

    content {

      rule_name                = rule.value.name
      target_vault_name        = rule.value.target_vault_name
      schedule                 = rule.value.schedule
      start_window             = rule.value.start_window
      completion_window        = rule.value.completion_window
      recovery_point_tags      = var.tags
      enable_continuous_backup = rule.value.enable_continuous_backup



      dynamic "lifecycle" {
        for_each = rule.value.lifecycle
        content {
          cold_storage_after = lifecycle.value.cold_storage_after
          delete_after       = lifecycle.value.delete_after
        }

      }

      dynamic "copy_action" {
        for_each = rule.value.copy_action
        content {
          destination_vault_arn = copy_action.value.destination_vault_arn

          dynamic "lifecycle" {
            for_each = copy_action.value.lifecycle
            content {
              cold_storage_after = lifecycle.value.cold_storage_after
              delete_after       = lifecycle.value.delete_after
            }

          }
        }
      }
    }

  }

  tags = var.tags

  depends_on = [module.backup_vault]
}

# Create backup vault
module "backup_vault" {
  source = "./modules/backup-vault"

  count = var.backup_vault_data == null ? 0 : 1

  name                            = var.backup_vault_data.name
  enable_encryption               = var.backup_vault_data.enable_encryption
  backup_role_name                = var.backup_vault_data.backup_role_name
  kms_key_deletion_window_in_days = var.backup_vault_data.kms_key_deletion_window_in_days
  kms_key_admin_arns              = var.backup_vault_data.kms_key_admin_arns

  tags = var.tags

  depends_on = [aws_iam_role.this]
}

# Resources are selected based on tags
resource "aws_backup_selection" "this" {
  count = var.backup_selection_data == null ? 0 : 1

  iam_role_arn = var.create_role ? aws_iam_role.this[0].arn : data.aws_iam_role.this[0].arn
  name         = var.backup_selection_data.name
  plan_id      = aws_backup_plan.this[0].id

  resources = var.backup_selection_data.resources

  condition {
    dynamic "string_equals" {
      for_each = var.backup_selection_data.selection_tags
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }

  depends_on = [aws_iam_role.this]
}

resource "aws_backup_vault_lock_configuration" "this" {
  count = var.vault_lock_configuration == null ? 0 : 1

  backup_vault_name   = var.vault_lock_configuration.vault_name
  changeable_for_days = var.vault_lock_configuration.changeable_for_days
  max_retention_days  = var.vault_lock_configuration.max_retention_days
  min_retention_days  = var.vault_lock_configuration.min_retention_days

  depends_on = [module.backup_vault]
}
