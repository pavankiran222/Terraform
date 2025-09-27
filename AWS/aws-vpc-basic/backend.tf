terraform {
  backend "s3" {
    bucket         = "terraform-state-pavankiran222"
    key            = "aws-vpc-basic/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}