terraform {
  backend "s3" {
    bucket         = "iam-modules-tfstate-bucket"
    key            = "iam-modules/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "iam-modules-state-lock"
  }
}

