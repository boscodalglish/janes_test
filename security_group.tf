# /* Private SG and rules */

# resource "aws_security_group" "Priavte_SG_ allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.main.cidr_block]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "Private instance allow_tls"
#   }
# }

# resource "aws_security_group_rule" "private_subnet_ingress" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   description       = "HTTPS"
#   cidr_blocks       = local.private_subnets
#   security_group_id = module.vpc.default_security_group_id
# }

# resource "aws_security_group_rule" "private_subnet_ingress" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   description       = "HTTPS"
#   cidr_blocks       = local.private_subnets
#   security_group_id = module.vpc.default_security_group_id
# }