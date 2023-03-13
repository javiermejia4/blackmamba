variable "vpc" {
  default     = "vpc-0e9ef16301c0f5b0f"
  description = "VPC-ID"
}

variable "region" {
  default     = "us-west-2"
  description = "Default Region"
}

variable "ami" {
  default     = "ami-036e879e3a42dd7ff"
  description = "AWS AMI"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "EC2 Instance Type"
}

variable "spot_price" {
  default     = "0.60"
  description = "EC2 Spot Price"
}