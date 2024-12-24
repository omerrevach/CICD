terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }

  required_version = ">= 1.2.0"
  
}
provider "aws" {
  region = "eu-north-1"
}
