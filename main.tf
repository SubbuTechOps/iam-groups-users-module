module "iam_users" {
  source                   = "./modules/iam"
  admin_users              = ["admin1", "admin2"]
  developer_users          = ["dev1", "dev2"]
  use_existing_admin_group = false
  use_existing_dev_group   = false
  project                  = "myproject"
  environment              = "prod"
}
