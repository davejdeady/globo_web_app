##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES #
resource "aws_instance" "nginx_instances" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.aws_instance_sizes.small
  subnet_id              = aws_subnet.public_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]

  user_data = templatefile("${path.module}/templates/startup_script.tpl",{s3_bucket_name = aws_s3_bucket.web_bucket.id})

  tags = local.common_tags




}



#aws_iam_role

resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = local.common_tags

}


#aws_iam_instance_profile#
#data "aws_iam_instance_profile" "nginx_profile" {
#  name = "nginx_profile"
#}
resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name
}



#aws_iam_role_policy
resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.name


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${local.s3_bucket_name}/"
        Resource = "arn:aws:s3:::${local.s3_bucket_name}/website/*"
      },
    ]
  })
}
