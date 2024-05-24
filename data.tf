data "aws_iam_role" "this" {
  count = var.create_role ? 0 : 1
  name  = var.role_name
}
