module "networking" {
  source = "./modules/networking"

  vpc_cidr = var.vpc_cidr

  public_subnets      = var.public_subnets
  eks_private_subnets = var.eks_private_subnets

  tags = local.tags

}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "tcc-eks-cluster"
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.eks_private_subnet_ids
  security_group_ids = [module.networking.eks_security_group_id]

  node_group_name           = "default"
  node_group_instance_types = ["t3.micro"]
  node_group_desired_size   = 2
  node_group_min_size       = 1
  node_group_max_size       = 3

  tags = local.tags
}
