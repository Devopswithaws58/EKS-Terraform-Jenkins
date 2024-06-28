terraform {
  backend "s3" {
    bucket = "terraform-eks-cicd-9399"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
  }
}