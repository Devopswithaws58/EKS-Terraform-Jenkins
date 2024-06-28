variable "aws_region" {
  description = "region for the jenkins sever"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}
variable "public_subnets" {
  description = "cidr values for subnets"
  type        = list(string)
}
variable "private_subnets" {
  description = "cidr values for subnets"
  type        = list(string)
}