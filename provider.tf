provider "aws" {
  region      = "eu-west-2"
  max_retries = 5
  access_key  = var.access_key
  secret_key  = var.secret_key
  default_tags {
    tags = var.tags
  }
}
