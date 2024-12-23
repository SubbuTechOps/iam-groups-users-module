# outputs.tf
output "admin_group_name" {
  value = local.admin_group_name
}

output "developer_group_name" {
  value = local.dev_group_name
}

output "created_admin_users" {
  value = aws_iam_user.admin_users[*].name
}

output "created_developer_users" {
  value = aws_iam_user.developer_users[*].name
}

output "admin_access_credentials" {
  value = {
    for i, user in aws_iam_user.admin_users : user.name => {
      access_key_id     = aws_iam_access_key.admin_user_keys[i].id
      secret_access_key = aws_iam_access_key.admin_user_keys[i].secret
    }
  }
  sensitive = true
}

output "developer_access_credentials" {
  value = {
    for i, user in aws_iam_user.developer_users : user.name => {
      access_key_id     = aws_iam_access_key.developer_user_keys[i].id
      secret_access_key = aws_iam_access_key.developer_user_keys[i].secret
    }
  }
  sensitive = true
}
