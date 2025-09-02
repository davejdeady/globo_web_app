variable "aws_region" {
  description = "aws region being used"
  type        = list(string)
  default     = ["eu-west-1", "eu-west-2"]
}

variable "aws_instance_sizes" {
  type        = map(string)
  description = "instance sizes to use in aws"
  default = {
    small  = "t2.micro"
    medium = "t3.micro"
    large  = "m4.large"
  }
}

variable "aws_access_key" {
  type        = string
  description = "aws access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "aws secret key"
  sensitive   = true
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr block for vpc"
}

variable "subnet_cidr_block" {
  type        = string
  default     = "10.0.10.0/24"
  description = "cidr block for subnet"
}


variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "enable dns hostnames for vpc"
}

variable "map_public_ip" {
  type        = bool
  default     = true
  description = "enable dns hostnames for vpc"
}

variable "nginx_sg_ingress_port" {
  type        = number
  default     = 80
  description = "nginx sg ingress port"
}

variable "nginx_sg_outbound_port" {
  type        = number
  default     = 0
  description = "nginx sg outbound port"
}

variable "project" {
  type        = string
  description = "project name"

}

variable "billing_code" {
  type        = string
  description = "billing_code"
}

variable "company" {
  type        = string
  default     = "Globomantics"
  description = "company name"

}