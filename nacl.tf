resource "aws_network_acl" "main" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.0.101.0/24"
    from_port  = 0
    to_port    = 61000
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = "10.0.102.0/24"
    from_port  = 0
    to_port    = 61000
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 302
    action     = "allow"
    cidr_block = "10.0.103.0/24"
    from_port  = 0
    to_port    = 61000
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.0.101.0/24"
    from_port  = 0
    to_port    = 61000
  }

  egress {
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = "10.0.102.0/24"
    from_port  = 0
    to_port    = 61000
  }

  egress {
    protocol   = "tcp"
    rule_no    = 302
    action     = "allow"
    cidr_block = "10.0.103.0/24"
    from_port  = 0
    to_port    = 61000
  }

tags = {
    Name = "nacl_main_${local.name}"
  }

depends_on = [
  module.vpc.private_subnets
]
lifecycle {
  create_before_destroy = true
}
}

resource "aws_network_acl_association" "main" {
  for_each = toset(module.vpc.private_subnets)
  network_acl_id = aws_network_acl.main.id
  subnet_id      = each.value
  depends_on = [
    module.vpc.private_subnets,
    aws_network_acl.main
  ]
lifecycle {
  create_before_destroy = true
}
}