terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider for us-east-1 region
provider "aws" {
  region = "us-east-1"
}

# Configure the AWS Provider for ap-south-1 region
provider "aws" {
  alias  = "ap_south_1"
  region = "ap-south-1"
}

# Security Group in us-east-1
resource "aws_security_group" "ec2_sg_us_east" {
  provider    = aws
  name        = "ec2_security_group_us_east"
  description = "Allow inbound and outbound traffic for specific ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2083
    to_port     = 2083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2087
    to_port     = 2087
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2_Security_Group_us_east"
  }
}

# EC2 Instance in us-east-1
resource "aws_instance" "ec2_instance_us_east" {
  provider      = aws
  ami           = "ami-032dd4fabc6bad9e4"
  instance_type = "t2.medium"
  key_name      = "cpanel"
  vpc_security_group_ids = [aws_security_group.ec2_sg_us_east.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    curl -o latest -L https://securedownloads.cpanel.net/latest
    sh latest
  EOF

  tags = {
    Name = "CPanel_us_east"
  }
}

# Elastic IP Association in us-east-1 (existing EIP)
resource "aws_eip_association" "ec2_eip_association_us_east" {
  provider     = aws
  instance_id  = aws_instance.ec2_instance_us_east.id
  allocation_id = "eipalloc-0fccf60f022b73c44"
}

# Security Group in ap-south-1
resource "aws_security_group" "ec2_sg_ap_south" {
  provider    = aws.ap_south_1
  name        = "ec2_security_group_ap_south"
  description = "Allow inbound and outbound traffic for specific ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2083
    to_port     = 2083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2087
    to_port     = 2087
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2_Security_Group_ap_south"
  }
}

# EC2 Instance in ap-south-1
resource "aws_instance" "ec2_instance_ap_south" {
  provider      = aws.ap_south_1
  ami           = "ami-0fa44a907cb3036d1"  # AlmaLinux AMI ID for ap-south-1
  instance_type = "t2.medium"
  key_name      = "south"  # Key pair for ap-south-1
  vpc_security_group_ids = [aws_security_group.ec2_sg_ap_south.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    curl -o latest -L https://securedownloads.cpanel.net/latest
    sh latest
  EOF

  tags = {
    Name = "CPanel_ap_south"
  }
}

# Elastic IP Association in ap-south-1 (existing EIP)
resource "aws_eip_association" "ec2_eip_association_ap_south" {
  provider     = aws.ap_south_1
  instance_id  = aws_instance.ec2_instance_ap_south.id
  allocation_id = "eipalloc-0046f5aaab05aaf41"  # Elastic IP for ap-south-1
}

# Outputs
output "us_east_security_group_id" {
  description = "The ID of the security group in us-east-1"
  value       = aws_security_group.ec2_sg_us_east.id
}

output "ap_south_security_group_id" {
  description = "The ID of the security group in ap-south-1"
  value       = aws_security_group.ec2_sg_ap_south.id
}

output "us_east_ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance in us-east-1"
  value       = aws_instance.ec2_instance_us_east.public_ip
}

output "ap_south_ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance in ap-south-1"
  value       = aws_instance.ec2_instance_ap_south.public_ip
}
