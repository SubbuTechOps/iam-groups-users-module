# main.tf
locals {
  admin_group_name = var.use_existing_admin_group ? var.admin_group_name : "${var.project}-${var.environment}-admins"
  dev_group_name = var.use_existing_dev_group ? var.developer_group_name : "${var.project}-${var.environment}-developers"
  
  new_admin_users = var.admin_users
  new_dev_users = var.developer_users
}

# Password Policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 12
  require_lowercase_characters   = true
  require_numbers               = true
  require_uppercase_characters   = true
  require_symbols               = true
  allow_users_to_change_password = true
  password_reuse_prevention     = 24
  max_password_age             = 90
}

# Admin Group
resource "aws_iam_group" "admin_group" {
  count = var.use_existing_admin_group ? 0 : 1
  name  = local.admin_group_name
}

resource "aws_iam_group_policy_attachment" "admin_policy" {
  count      = var.use_existing_admin_group ? 0 : 1
  group      = aws_iam_group.admin_group[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  depends_on = [aws_iam_group.admin_group]
}

# Developer Group
resource "aws_iam_group" "developer_group" {
  count = var.use_existing_dev_group ? 0 : 1
  name  = local.dev_group_name
}

resource "aws_iam_group_policy" "developer_policy" {
  count = var.use_existing_dev_group ? 0 : 1
  name  = "${var.project}-${var.environment}-developer-policy"
  group = aws_iam_group.developer_group[0].name
  depends_on = [aws_iam_group.developer_group]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "s3:List*",
          "s3:Get*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

# User Creation
resource "aws_iam_user" "admin_users" {
  count = length(local.new_admin_users)
  name  = "${var.project}-${var.environment}-${local.new_admin_users[count.index]}"
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Role        = "Admin"
  }
  force_destroy = true
}

resource "aws_iam_user" "developer_users" {
  count = length(local.new_dev_users)
  name  = "${var.project}-${var.environment}-${local.new_dev_users[count.index]}"
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Role        = "Developer"
  }
  force_destroy = true
}

# Group Memberships
resource "aws_iam_user_group_membership" "admin_user_membership" {
  count = length(local.new_admin_users)
  user  = aws_iam_user.admin_users[count.index].name
  groups = [aws_iam_group.admin_group[0].name]
  depends_on = [aws_iam_group.admin_group, aws_iam_user.admin_users]
}

resource "aws_iam_user_group_membership" "developer_user_membership" {
  count = length(local.new_dev_users)
  user  = aws_iam_user.developer_users[count.index].name
  groups = [aws_iam_group.developer_group[0].name]
  depends_on = [aws_iam_group.developer_group, aws_iam_user.developer_users]
}

# Initial Access Keys
resource "aws_iam_access_key" "admin_user_keys" {
  count = length(local.new_admin_users)
  user  = aws_iam_user.admin_users[count.index].name
  depends_on = [aws_iam_user.admin_users]
}

resource "aws_iam_access_key" "developer_user_keys" {
  count = length(local.new_dev_users)
  user  = aws_iam_user.developer_users[count.index].name
  depends_on = [aws_iam_user.developer_users]
}
