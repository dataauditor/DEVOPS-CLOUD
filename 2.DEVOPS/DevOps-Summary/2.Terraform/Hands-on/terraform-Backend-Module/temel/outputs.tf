
output "subnetid" {
  value = aws_subnet.public_subnet.id
}

output "secgr" {
  value = aws_security_group.vpc-tf-sec-gr.id
}