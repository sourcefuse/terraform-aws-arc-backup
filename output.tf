output "backup_role_arn" {
  description = "IAM Role for taking backups"
  value       = var.create_role ? aws_iam_role.this[0].arn : null
}

output "backup_plan_id" {
  description = "AWS backups plan ID"
  value       = var.backup_plan == null ? null : aws_backup_plan.this[0].id
}
