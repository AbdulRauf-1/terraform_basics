terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "state-bucket-1212"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "state-table1212"
  }
}