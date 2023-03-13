terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket  = "janes-tfstate"
    key     = "janes-tfstate.tfstate"
    region  = "eu-west-1"
    encrypt = "true"
    dynamodb_table = "terraform-lock"
  }
}