resource "aws_kms_key" "this" {
  count                   = var.enable_encryption && var.kms_key_arn == null ? 1 : 0
  description             = "KMS key used for AWS backup service for encryption"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  policy                  = data.aws_iam_policy_document.this.json
}

# Create backup vault with kms key
resource "aws_backup_vault" "this" {
  name        = var.name
  kms_key_arn = var.enable_encryption ? (var.kms_key_arn != null ? var.kms_key_arn : aws_kms_key.this[0].arn) : null

  tags = var.tags
}
