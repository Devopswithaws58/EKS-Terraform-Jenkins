terraform {
  backend "s3" {
    bucket = "eks-terraform-cicd-lwplabs"
    key    = "jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}