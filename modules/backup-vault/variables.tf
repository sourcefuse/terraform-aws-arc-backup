variable "tags" {
  type        = map(string)
  description = "Tags for AWS backup service"
}

variable "name" {
  type        = string
  description = "Name of backup vault"
}

variable "enable_encryption" {
  type        = bool
  description = "Whether to enable encryption"
  default     = true

}

variable "kms_key_deletion_window_in_days" {
  description = "Deletion window for KMS key in days."
  type        = number
  default     = 10
}

variable "kms_key_admin_arns" {
  description = "Additional IAM roles to map to the KMS key policy for administering the KMS key used for SSE."
  default     = []
  type        = list(string)
}

variable "backup_role_name" {
  description = "IAM role used to take backup of AWS resources"
  type        = string
}
