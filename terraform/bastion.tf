locals {
  ec2-instance = {
    "01" = {
      ami                        = "ami-058168290d30b9c52"
      instance_type              = "t3.micro"
      home_ebs_volume_throughput = "125"
      home_ebs_volume_size       = "5"
      data_ebs_volume_throughput = "125"
      data_ebs_volume_size       = "5"
      opt_ebs_volume_throughput  = "125"
      opt_ebs_volume_size        = "8"

    }
    "02" = {
      ami                        = "ami-058168290d30b9c52"
      instance_type              = "t3.micro"
      home_ebs_volume_throughput = "125"
      home_ebs_volume_size       = "5"
      data_ebs_volume_throughput = "125"
      data_ebs_volume_size       = "5"
      opt_ebs_volume_throughput  = "125"
      opt_ebs_volume_size        = "8"

    }
    "03" = {
      ami                        = "ami-058168290d30b9c52"
      instance_type              = "t3.micro"
      home_ebs_volume_throughput = "125"
      home_ebs_volume_size       = "5"
      data_ebs_volume_throughput = "125"
      data_ebs_volume_size       = "5"
      opt_ebs_volume_throughput  = "125"
      opt_ebs_volume_size        = "8"

    }
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  for_each               = { for k, v in local.ec2-instance : k => v if var.environment == "dev" }
  name                   = "blackmamba-bastion-${each.key}"
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  key_name               = "blackmamba"
  create_spot_instance   = false
  spot_price             = var.spot_price
  spot_type              = "persistent"
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name
  monitoring             = false
  user_data = base64encode(templatefile("./templates/userdata.tpl", {

  }))

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
      Role = "Bastion"
    },
    local.common_tags
  )

}

resource "aws_ebs_volume" "home" {
  for_each          = { for k, v in local.ec2-instance : k => v if var.environment == "dev" }
  availability_zone = module.ec2_instance[each.key].availability_zone
  encrypted         = true
  type              = "gp3"
  throughput        = each.value.home_ebs_volume_throughput
  size              = each.value.home_ebs_volume_size
}

resource "aws_volume_attachment" "attach-home" {
  for_each    = { for k, v in local.ec2-instance : k => v if var.environment == "dev" }
  device_name = "/dev/xvdf"
  instance_id = module.ec2_instance[each.key].id
  volume_id   = aws_ebs_volume.home[each.key].id
}

resource "aws_ebs_volume" "data" {
  for_each          = { for k, v in local.ec2-instance : k => v if var.environment == "dev" }
  availability_zone = module.ec2_instance[each.key].availability_zone
  encrypted         = true
  type              = "gp3"
  throughput        = each.value.data_ebs_volume_throughput
  size              = each.value.data_ebs_volume_size
}

resource "aws_volume_attachment" "attach-data" {
  for_each    = { for k, v in local.ec2-instance : k => v if var.environment == "dev" }
  device_name = "/dev/xvdg"
  instance_id = module.ec2_instance[each.key].id
  volume_id   = aws_ebs_volume.data[each.key].id
}

resource "aws_ebs_volume" "opt" {
  for_each          = { for k, v in local.ec2-instance : k => v if var.environment == "dev" }
  availability_zone = module.ec2_instance[each.key].availability_zone
  encrypted         = true
  type              = "gp3"
  throughput        = each.value.opt_ebs_volume_throughput
  size              = each.value.opt_ebs_volume_size
}

resource "aws_volume_attachment" "attach-opt" {
  for_each    = { for k, v in local.ec2-instance : k => v if var.environment == "dev" }
  device_name = "/dev/xvdh"
  instance_id = module.ec2_instance[each.key].id
  volume_id   = aws_ebs_volume.opt[each.key].id
}