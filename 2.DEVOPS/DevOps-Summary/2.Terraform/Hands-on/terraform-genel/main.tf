terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}

resource "aws_instance" "tf-ec2" {
#  ami           = var.instance-ami
  ami           = data.aws_ami.tf_ami.id
  instance_type = var.ec2-tipi 
  key_name      = "ugur"
  tags = {
    # Name = "${var.ec2-name}-ttttt"    # variableden
    Name = "${local.instance-name}-come from local"
  }
}

resource "aws_s3_bucket" "tf-s3" {
#  bucket = "${var.s3-bucket-name}-${count.index}"
  acl    = "private"
#  count = var.num_of_buckets
#  count = var.num_of_buckets != 0 ? var.num_of_buckets :3
  for_each = toset(var.users)                                # alt satirla birlikte kullanilir.
  bucket = "example-s3-bucket-${each.value}"                 # yukari ile beraber kullanilir. " " kullanmamaizin sebebi ek isim koydugumuzdan degiskeni yalniz kullanamadigimizdan.
}

resource "aws_iam_user" "new_user" {
  for_each = toset(var.users)                # farkli userlar verme
  name = each.value  
}

locals {
  instance-name = "umit"
}

