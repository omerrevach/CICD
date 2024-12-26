terraform {
  backend "s3" {
    bucket         = "my-terraform-state-file-leumi"
    key            = "jenkins/terraform.tfstate"
    region         = "eu-north-1"
  }
}
