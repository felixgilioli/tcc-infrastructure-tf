module "networking" {
  source = "./modules/networking"

  vpc_cidr = var.vpc_cidr

  public_subnets      = var.public_subnets
  eks_private_subnets = var.eks_private_subnets
  rds_private_subnets = var.rds_private_subnets

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

module "rds" {
  source = "./modules/rds"

  db_name     = "fastfood"
  db_username = "root"
  db_password = "1234" # Em produção, usar um secret manager

  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.rds_private_subnet_ids
  security_group_ids = [module.networking.rds_security_group_id]

  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  max_allocated_storage   = 100
  backup_retention_period = 7
  skip_final_snapshot     = true # Em produção, definir como false

  tags = local.tags
} 