output "backup_plan_id" {
  description = "AWS backups plan ID"
  value       = var.backup_plan == null ? null : aws_backup_plan.this[0].id
}

output "backup_role_arn" {
  value = var.create_role ? aws_iam_role.this[0].arn : data.aws_iam_role.this[0].arn
}

output "backup_role_name" {
  value = var.create_role ? aws_iam_role.this[0].id : data.aws_iam_role.this[0].id
}

output "vault_arn" {
  description = "ARN of Vault"
  value       = var.backup_vault_data == null ? null : module.backup_vault[0].arn
}
