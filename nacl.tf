resource "aws_network_acl" "main" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.0.101.0/24"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = "10.0.102.0/24"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 302
    action     = "allow"
    cidr_block = "10.0.103.0/24"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.0.101.0/24"
    from_port  = 32768
    to_port    = 61000
  }

  egress {
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = "10.0.102.0/24"
    from_port  = 32768
    to_port    = 61000
  }

  egress {
    protocol   = "tcp"
    rule_no    = 302
    action     = "allow"
    cidr_block = "10.0.103.0/24"
    from_port  = 32768
    to_port    = 61000
  }

tags = {
    Name = "nacl_main_${local.name}"
  }
}

resource "aws_network_acl_association" "main" {
  for_each = toset(module.vpc.private_subnets)
  network_acl_id = aws_network_acl.main.id
  subnet_id      = each.value
}