module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "bastion"

  description = "Security group for Bastion host"
  vpc_id      = var.vpc

  ingress_cidr_blocks = ["47.148.114.223/32"]
  ingress_rules       = ["ssh-tcp"]
}