##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region[0]
}



##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.common_tags


}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

  tags = local.common_tags

}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.subnet_cidr_block
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.map_public_ip

  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.app.id

  # HTTP access from anywhere
  ingress {
    from_port   = var.nginx_sg_ingress_port
    to_port     = var.nginx_sg_ingress_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = var.nginx_sg_outbound_port
    to_port     = var.nginx_sg_outbound_port
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}



