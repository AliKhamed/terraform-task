terraform {
  backend "s3" {
    bucket         = "alikhames508"
    key            = "terraform.tfstat"
    region         = "us-east-1"
    dynamodb_table = "terraformDDB"
  }
}