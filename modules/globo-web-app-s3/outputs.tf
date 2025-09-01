# bucket object

output "web_bucket" {

  value       = aws_s3_bucket.web_bucket
  description = "Name of the S3 bucket"

}

# instance profile object

output "instance profile" {
    value = aws_iam_instance_profile.nginx_profile
    description = "Name of the instance profile"
}
