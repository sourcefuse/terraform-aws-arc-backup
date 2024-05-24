variable "tags" {
  type        = map(string)
  description = "Tags for AWS backup service"
}

variable "backup_plan" {
  type = object({
    name = string
    rules = list(object({
      name                     = string
      target_vault_name        = string
      schedule                 = string
      start_window             = optional(string, null)
      completion_window        = optional(string, null)
      recovery_point_tags      = optional(map(string), {})
      enable_continuous_backup = optional(bool, false)
      lifecycle = list(object({
        cold_storage_after = optional(number, 0)
        delete_after       = number
      }))

      copy_action = optional(list(object({
        destination_vault_arn = string
        lifecycle = optional(list(object({
          cold_storage_after = string
          delete_after       = string
        })), [])
      })), [])

    }))
  })
  description = "Rules for AWS backup plan, null act as flag to enable or disable backup plan"
  default     = null
}

variable "backup_vault_data" {
  type = object({
    name                            = string
    backup_role_name                = string
    enable_encryption               = optional(bool, true)
    kms_key_deletion_window_in_days = optional(number, 7)
    kms_key_admin_arns              = optional(list(string), [])
  })
  description = "Details to create backup vault, null act as flag to enable or disable"
  default     = null
}

variable "create_role" {
  type        = bool
  description = "(optional) Role Required for taking backup and restore"
  default     = false
}

variable "role_name" {
  type        = string
  description = "IAM role name"
  default     = null
}

variable "backup_selection_data" {
  type = object({
    name      = string
    plan_name = string
    resources = optional(list(string), ["*"]) // List of resources eg [ "arn:aws:ec2:*:*:instance/*" ] , * -> All supported resources
    selection_tags = optional(list(object({
      type  = string
      key   = string
      value = string
    })), [])
  })
  description = "(optional) Backup selection criteria to select resources"
  default     = null
}

variable "vault_lock_configuration" {
  type = object({
    vault_name          = string
    changeable_for_days = number
    max_retention_days  = number
    min_retention_days  = number
  })
  description = "(optional) Vault lock configuration , changeable_for_days > 0 , then its `governance` else `compliance` mode"
  default     = null
}
