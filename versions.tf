terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      
    }
  }

  backend "s3" {
    bucket         = "onlinefilingv2-test-tfstate"
    key            = "onlinefilingv2-test-tfstate.tfstate"
    region         = "eu-west-2"
    encrypt        = "true"
  }
}
