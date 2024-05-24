data "aws_caller_identity" "current" {}

data "aws_iam_role" "this" {
  name = var.backup_role_name
}

data "aws_iam_policy_document" "this" {

  # Enable IAM User Permissions
  statement {
    actions = [
      "kms:*"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.kms_key_admin_arns
    } // Refer : https://stackoverflow.com/questions/48509193/getting-the-error-in-using-terraform-for-aws-the-new-key-policy-will-not-allow

    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.this.arn]
    }

    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.this.arn]
    }

    resources = ["*"]
  }

  statement {
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.this.arn]
    }

    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = [
        "true",
      ]
    }
  }

}
