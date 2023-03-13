locals {
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"

  tags = {
    Example = local.name
  }

  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  azs = ["${local.region}a", "${local.region}b", "${local.region}c"]
}
