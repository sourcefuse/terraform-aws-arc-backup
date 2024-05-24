
# For fetching role arn
/* TODO: Validate if the commented blocks are required for EC2 restore
data "aws_iam_role" "this" {
  name = var.this_role_name
}

# Needed to allow the backup service to restore from a snapshot to an this instance
data "aws_iam_policy_document" "pass_role" {
  statement {
    sid       = "PassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = [data.aws_iam_role.this.arn]
  }
}

resource "aws_iam_role_policy" "backup_service_pass_role_policy" {
  policy = data.aws_iam_policy_document.pass_role.json
  role   = aws_iam_role.this.name
}

*/

# Role for taking AWS Backups
resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0

  name        = var.role_name
  description = "Allows the AWS Backup Service to take scheduled backups"
  // Assume Role Policy for Backups
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : ["sts:AssumeRole"],
          Effect : "allow",
          Principal : {
            Service : ["backup.amazonaws.com"]
          }
        }
      ]
  })

  tags = var.tags
}

# The policies that allow the backup service to take backups
resource "aws_iam_role_policy_attachment" "aws_backup_policy_backup_attachment" {
  count      = var.create_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.this[0].name
}

# The policies that allow the backup service to do restores
resource "aws_iam_role_policy_attachment" "aws_backup_policy_restore_attachment" {
  count      = var.create_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.this[0].name
}
