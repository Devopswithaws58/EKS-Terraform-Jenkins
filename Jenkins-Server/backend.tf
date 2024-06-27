terraform {
  backend "s3" {
    bucket = "eks-terraform-terraform-lwplabs"
    key    = "jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}