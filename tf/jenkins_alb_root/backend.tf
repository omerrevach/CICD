terraform {
  backend "s3" {
    bucket         = "my-terraform-state-vpc"
    key            = "jenkins/terraform.tfstate"
    region         = "eu-north-1"
  }
}