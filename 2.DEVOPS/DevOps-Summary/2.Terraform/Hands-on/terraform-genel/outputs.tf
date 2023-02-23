output "tf-example-public-ip" {
  value = aws_instance.tf-ec2.public_ip
}

# output "tf-example-s3-meta" {
#   value = aws_s3_bucket.tf-s3.region
# }

output "iste" {
  value = aws_instance.tf-ec2.private_dns 
}

# output "tf-example-s3" {
#   value = aws_s3_bucket.tf-s3[*]
# }

output "upper" {
  value = [for x in var.users : upper(x) if length(x) > 6]
}