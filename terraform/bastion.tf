locals {
  #Nothing to see here

}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name                   = "bastion"
  count                  = var.instance_count[terraform.workspace]
  ami                    = var.ami[terraform.workspace]
  create_spot_instance   = true
  spot_price             = var.spot_price
  spot_type              = "persistent"
  instance_type          = var.instance_type[terraform.workspace]
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name
  key_name               = var.key_name
  monitoring             = false
  user_data              = base64encode(templatefile("./templates/userdata.tpl", {

  } ))

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = false
      volume_type           = "gp3"
      volume_size           = 20
    },
  ]

  tags = merge(
    {
      Name = "blackmamba-bastion-0${count.index + 1}"
      Role = "Bastion"
    },
    local.common_tags
  )

}