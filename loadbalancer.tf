# aws_elb_service_account
data "aws_elb_service_account" "root" {}


# aws_lb
resource "aws_lb" "nginx" {
  name               = "${local.naming_prefix}-globo-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  #subnets            = aws_subnet.public_subnets[*].id
  #subnets    = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  subnets = module.app.public_subnets
  #depends_on = [aws_s3_bucket_policy.web_bucket]
  depends_on = [module.web_bucket]


  enable_deletion_protection = false

  access_logs {
    bucket  = module.web_app_s3.web_bucket.id
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}

# aws_lb_target-group

resource "aws_lb_target_group" "nginx" {
  name     = "nginx-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.app.vpc_id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# aws_lb_listener

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = local.common_tags
}

# aws_lb_target_group_attachment

resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}

#resource "aws_lb_target_group_attachment" "nginx2" {
#  target_group_arn = aws_lb_target_group.nginx.arn
#  target_id        = aws_instance.nginx2.id
#  port             = 80
#}