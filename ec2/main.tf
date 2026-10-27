# Key Pair to ssh into our ec2

resource "aws_key_pair" "my_key" {
  key_name   = ""
  public_key = file("${path.module}/ec2-tf-key.pub")
}

# Default VPC

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

#Secuirity Groups

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow tls inbound and outbound traffic"
  vpc_id      = aws_default_vpc.default.id # interpolation
}

#Inbound traffic for port 22 for SSH

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

#Inbound traffic for port 80 for HTTP

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_tls.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

#Outbound rule to allow all traffic

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" #all porotocol
}

resource "aws_instance" "my-instance-1" {
  ami           = "ami-0c7632fb77f35db43"
  instance_type = "t3.micro"

  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "my-instance-1"
  }
}
