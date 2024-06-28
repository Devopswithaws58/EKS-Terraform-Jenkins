terraform {
  backend "s3" {
    bucket = "terraform-eks-cicd-9399"
    key    = "jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}