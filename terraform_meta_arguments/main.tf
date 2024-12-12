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

# resource "aws_instance" "ec2_instance" {
#     count = 4
#     ami = "ami-005fc0f236362e99f"
#     instance_type = "t2.micro"
#     tags = {
#       Name= "Terraform_Instance ${count.index}"
#     }
# } 

# output "ec2_public_ip" {
#   value = aws_instance.ec2_instance[2].public_ip
# }

# locals {
#   instances= toset(["Todd", "James", "Alice", "Dottie"])
# }

# # for each
# resource "aws_instance" "ec2_instance" {
#     for_each = local.instances
#     ami = "ami-005fc0f236362e99f"
#     instance_type = "t2.micro"
#     tags = {
#       Name= each.key
#     }
# } 


locals {
  instances= {"Todd":"ami-0453ec754f44f9a4a", "James":"ami-0e2c8caa4b6378d8c", "Alice":"ami-0583d8c7a9c35822c", "Dottie":"ami-0cd60fd97301e4b49"}
}

# for each
resource "aws_instance" "ec2_instance" {
    for_each = local.instances
    ami = each.value
    instance_type = "t2.micro"
    tags = {
      Name= each.key
    }
} 