output "public_dns_hostname" {
  value = "http://${aws_instance.nginx1.public_dns}"
}
