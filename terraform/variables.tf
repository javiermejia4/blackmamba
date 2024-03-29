variable "environment" {
  type        = string
  description = "Environment..."
  default     = ""
}

variable "region" {
  default     = "us-west-2"
  description = "Default Region"
}

variable "spot_price" {
  default     = "0.60"
  description = "EC2 Spot Price"
}

variable "key_name" {
  default     = "blackmamba"
  description = "blackmamba key"
}

variable "instance_count" {
  type        = map(number)
  description = "instance count"
  default = {
    dev  = "0"
    test = "0"
  }
}

variable "instance_type" {
  type        = map(string)
  description = "instance count"
  default = {
    dev  = "t3-micro"
    test = "t3-micro"
  }
}

variable "ami" {
  type        = map(string)
  description = "AWS AMI"
  default = {
    dev  = "ami-036e879e3a42dd7ff"
    test = "ami-036e879e3a42dd7ff"
  }
}

variable "enabled_keys" {
  type        = map(bool)
  description = "Enabled or not ..."
  default = {
    dev  = "true"
    test = "false"
  }
}

variable "enabled" {
  type        = bool
  default     = "0"
  description = "Enabled or not ..."

}