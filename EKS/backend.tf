terraform {
  backend "s3" {
    bucket = "cicd-terrraform-eks"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
  }
}