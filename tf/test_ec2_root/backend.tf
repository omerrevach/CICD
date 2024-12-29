terraform {
  backend "s3" {
    bucket         = "my-terraform-state-vpc"
    key            = "test-ec2/terraform.tfstate"
    region         = "eu-north-1"
  }
}