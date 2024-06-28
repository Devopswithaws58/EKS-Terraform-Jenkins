terraform {
  backend "s3" {
    bucket = "terraform-eks-cicd-9176"
    key    = "jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}