data "aws_instances" "private_instances" {
  instance_tags = {
    Name = "ex-janes-instance-private-v3"
  }
  filter {
    name   = "tag:Name"
    values = ["ex-janes-instance-private-v3"]
  }
  instance_state_names = ["running"]
}

data "aws_instances" "public_instances" {
  instance_tags = {
    Name = "ex-janes-instance-public-v3"
  }
  filter {
    name   = "tag:Name"
    values = ["ex-janes-instance-public-v3"]
  }
  instance_state_names = ["running"]
}

# /* Private SG and rules */

resource "aws_security_group" "private_alb_sg" {
  name        = "private_alb_sg"
  description = "Private ALB SG"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private ALB SG"
  }
}

resource "aws_security_group" "public_alb_sg" {
  name        = "public_alb_sg"
  description = "Public ALB SG"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "TLS from VPC"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.Public_SG_allow_tls.id]
  }

  egress {
    description     = "TLS from VPC"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.Public_SG_allow_tls.id]
  }

  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public ALB SG"
  }
}

/*Private ALB*/
resource "aws_alb_target_group" "private_http" {

  name        = "instance-private-http"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    matcher = "200-299"
    path    = "/healthz"
  }

  vpc_id = module.vpc.vpc_id

}

resource "aws_lb_target_group_attachment" "private_test" {
  count            = length(data.aws_instances.private_instances.ids)
  target_group_arn = aws_alb_target_group.private_http.arn
  target_id        = data.aws_instances.private_instances.ids[count.index]
  port             = 80
}

resource "aws_alb" "private" {

  name            = "instance-private-alb"
  subnets         = module.vpc.private_subnets
  security_groups = [aws_security_group.private_alb_sg.id]
  internal        = false

}

resource "aws_alb_listener" "private_http" {

  load_balancer_arn = aws_alb.private.id
  port              = 80
  protocol          = "HTTP"

  #   ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  #   certificate_arn = element(
  #     aws_acm_certificate_validation.private_cert.*.certificate_arn,
  #     0,
  #   )

  default_action {
    target_group_arn = aws_alb_target_group.private_http.id
    type             = "forward"
  }

}



/*Public ALB*/
resource "aws_alb_target_group" "public_http" {

  name        = "instance-public-http"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    matcher = "200-499"
    path    = "/healthz"
  }

  vpc_id = module.vpc.vpc_id

}

resource "aws_lb_target_group_attachment" "public_test" {
  count            = length(data.aws_instances.public_instances.ids)
  target_group_arn = aws_alb_target_group.public_http.arn
  target_id        = data.aws_instances.public_instances.ids[count.index]
  port             = 80
}

resource "aws_alb" "public" {

  name            = "instance-public-alb"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.public_alb_sg.id]
  internal        = false

}

resource "aws_alb_listener" "public_http" {

  load_balancer_arn = aws_alb.public.id
  port              = 80
  protocol          = "HTTP"

  #   ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  #   certificate_arn = element(
  #     aws_acm_certificate_validation.private_cert.*.certificate_arn,
  #     0,
  #   )

  default_action {
    target_group_arn = aws_alb_target_group.public_http.id
    type             = "forward"
  }

}
