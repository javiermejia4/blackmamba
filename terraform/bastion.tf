module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name = "bastion"

  create_spot_instance = true
  spot_price           = var.spot_price
  spot_type            = "persistent"
  key_name             = "blackmamba"

  ami                    = var.ami
  instance_type          = var.instance_type
  monitoring             = false
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}