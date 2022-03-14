variable "vpc-id" {
  default     = "vpc-0166425ed9bb74f12"
  description = "VPC-ID"
}

variable "region" {
  default     = "us-west-2"
  description = "Default Region"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List if Ingress ports"
  default     = [443,3389]
}

variable "allowed_ips" {
  type        = list(string)
  description = "Allowed cidr IPs"
  default     = ["45.50.88.178/32"]
}