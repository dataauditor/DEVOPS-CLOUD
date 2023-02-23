terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.56.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}

resource "aws_instance" "tf-ec2" {
  ami           = "ami-0c2b8ca1dad447f8a"
  instance_type = "t2.micro"
  tags = {
    "Name" = "created-by-tf"
  }
}

