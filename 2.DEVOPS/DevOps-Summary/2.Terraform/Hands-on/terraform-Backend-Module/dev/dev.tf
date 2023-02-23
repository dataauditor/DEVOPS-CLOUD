provider "aws" {
  region = "us-east-1"
  profile = "cw-training"
}

module "tf-vpc" {
  source = "./module"
  env = "DEV"
}


resource "aws_instance" "tf-module-ec2" {
  ami = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.tf-vpc.secgr]
  subnet_id = module.tf-vpc.subnetid
}

output "subnet" {
  value = module.tf-vpc.subnetid
}

output "scgr" {
  value = module.tf-vpc.secgr
}

output "ec2subnetid" {
  value = aws_instance.tf-module-ec2.subnet_id
}

output "vpcsgr" {
  value = aws_instance.tf-module-ec2.vpc_security_group_ids
}