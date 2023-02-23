variable "ec2-name" {
  default = "oliver-ec2"
}

variable "ec2-tipi" {
  default = "t2.micro"
} 

# variable "instance-ami" {            # data.tf'ten cektigi icin burasi comment
#   default = "ami-09e67e426f25ce0d7"
# }

variable "s3-bucket-name" {
  default = "umit-deneme-1112"
}

variable "num_of_buckets" {       # sayiyi "apply"dan sonra sorar.
}

variable "users"{
  default = ["spring11", "micheal11", "oliver11"]
}