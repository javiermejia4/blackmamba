resource "aws_security_group" "allow_tls" {
  name        = "Blackmamba-sg-allow-TLS"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = var.allowed_ips
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Blackmamba-sg-allow-TLS"
  }
}