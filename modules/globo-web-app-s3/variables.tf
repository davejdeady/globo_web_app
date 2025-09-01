# bucket name
variable "bucket_name" {
  type        = bool
  description = "S3 bucket name"
}

# elb service account

variable "aws_elb_service_account"{
    type = string
    description = "ARN of ELB service account"
}

# common tags

variable "common_tags" {
    type = map(string)
    description = "Map of tags to be used for all resources"
    default = {}
    
}