# data.tf
# Only check for existing groups
data "aws_iam_group" "existing_admin_group" {
  count = var.use_existing_admin_group ? 1 : 0
  group_name = var.admin_group_name
}

data "aws_iam_group" "existing_dev_group" {
  count = var.use_existing_dev_group ? 1 : 0
  group_name = var.developer_group_name
}
