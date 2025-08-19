output "aws_alb_public_dns" {
  value       = "http://${aws_lb.nginx.dns_name}"
  description = "Public DNS hostname for the instance"
}

output "aws_s3_name" {

  value       = local.s3_bucket_name
  description = "Name of the S3 bucket"

}

