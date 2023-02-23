data "aws_ami" "tf_ami" {
  most_recent = true
  owners = ["self"]    # ya da hesap numarasi kullanilir
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}