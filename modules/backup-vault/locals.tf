locals {

  kms_key_admin_arns = concat([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    data.aws_caller_identity.current.arn
  ], var.kms_key_admin_arns)
  // Refer why root has to be included
  // : https://stackoverflow.com/questions/48509193/getting-the-error-in-using-terraform-for-aws-the-new-key-policy-will-not-allow
}
