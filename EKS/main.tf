########################  VPC Creation ############################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "EKS-VPC"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.available.names
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  enable_dns_support      = true

  public_subnet_tags = {
    "Name"                                 = "jenkins-public-subnet"
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = "1"
  }
  private_subnet_tags = {
    "Name"                                 = "jenkins-private-subnet"
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"      = "1"
  }

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    Name                                   = "my-eks-cluster-VPC"
    Terraform                              = "true"
    Environment                            = "dev"
  }

}


####################   EKS Cluster Creation #####################

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_type = ["t2.small"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}