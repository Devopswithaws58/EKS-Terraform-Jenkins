output "aws_ami_owner" {
  value = data.aws_ami.redhat-linux-9.image_id
}