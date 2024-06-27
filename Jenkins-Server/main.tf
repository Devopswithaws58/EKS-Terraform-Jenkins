########################  VPC Creation ############################ 
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
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

  public_route_table_tags = {
    "Name" = "Jenkis-Publc-RT"
  }
  default_route_table_tags = {
    "Name" = "jenkins-default-RT"
  }

  igw_tags = {
    "Name" = "jenkis-IGW"
  }

  default_security_group_tags = {
    "Name" = "jenkins-vpc-SG"
  }

  default_network_acl_tags = {
    "Name" = "jenkins-vpc-nacl"
  }

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    Name                                   = "Jenkins-VPC"
    Terraform                              = "true"
    Environment                            = "dev"
  }

}

#########################   Security Group Creation #####################

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Jenkins-SG"
  description = "Security group for Jenkins-Server with custom ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"

    }
  ]

  tags = {
    Name = "Jenkins-SG"
  }
}

################### EC2 Instance Creation ####################

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type               = var.instance_type
  key_name                    = "b90-key"
  monitoring                  = true
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  availability_zone           = data.aws_availability_zones.available.names[0]
  user_data                   = file("jenkins_install.sh")

  tags = {
    Name        = "Jenkins-server"
    Terraform   = "true"
    Environment = "dev"
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