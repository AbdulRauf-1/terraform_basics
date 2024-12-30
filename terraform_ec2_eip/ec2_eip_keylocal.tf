terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Security Group to allow specific inbound and outbound traffic
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow inbound and outbound traffic for specific ports"

  # Inbound rules
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
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2_Security_Group"
  }
}

# Elastic IP
resource "aws_eip" "ec2_eip" {
  domain = "vpc"
}

# Key Pair
resource "aws_key_pair" "deployer_key" {
  key_name   = "ec2_key"
  public_key = file("~/.ssh/ec2_key.pub")
}



# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name

  # Attach Security Group
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Associate Elastic IP
  associate_public_ip_address = true

  # Root block device (EBS volume)
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "Terraform_Instance"
  }
}

# Elastic IP Association
resource "aws_eip_association" "ec2_eip_association" {
  instance_id = aws_instance.ec2_instance.id
  allocation_id = aws_eip.ec2_eip.id
}

# Outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.ec2_sg.name
}

output "elastic_ip" {
  description = "The Elastic IP address assigned to the instance"
  value       = aws_eip.ec2_eip.public_ip
}

output "ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}
