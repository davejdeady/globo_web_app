output "aws_public_dns" {
  value = "http://${aws_lb.nginx.dns_name}"
  description = "Public DNS for the ALB instance"
}
