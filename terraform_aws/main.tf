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

resource "aws_instance" "ec2_instance" {
    ami = "ami-005fc0f236362e99f"
    instance_type = "t2.micro"
    tags = {
      Name= "Terraform_Instance"
    }
} 

resource "aws_s3_bucket" "my_bucket" {
  bucket = "rauf12122024"
  tags = {
    Name="My Bucket"

  } 
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}