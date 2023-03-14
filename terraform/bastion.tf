locals {
  #Nothing to see here

}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion_profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role" "bastion_role" {
  name = "bastion_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = merge(
    {
      Role = "Bastion"
    },
  )
}

resource "aws_iam_policy" "bastion_policy" {
  name        = "bastion_policy"
  path        = "/"
  description = "Bastion Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "s3:*",
          "ssm:*",
          "secretsmanager:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "bastion-policy-attach" {
  name       = "bastion-policy-attachment"
  roles      = [aws_iam_role.bastion_role.name]
  policy_arn = aws_iam_policy.bastion_policy.arn
}

module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "4.3.0"
  name                   = "bastion"
  count                  = var.instance_count
  ami                    = var.ami
  create_spot_instance   = true
  spot_price             = var.spot_price
  spot_type              = "persistent"

  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 20
      volume_type           = "gp3"
    },
  ]

  tags = merge(
    {
      Name = "blackmamba-bastion-0${count.index +1}"
      Role = "Bastion"
    },
    local.common_tags
  )

}