module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "${var.environment}-bastion-sg"

  description = "Security group for Bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["47.148.114.223/32"]
  ingress_rules       = ["ssh-tcp"]
}