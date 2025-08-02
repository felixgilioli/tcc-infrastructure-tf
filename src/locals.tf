locals {
  tags = merge(
    var.tags,
    {
      Environment = "tcc"
      Projeto     = "tcc-aws-tf"
    }
  )

  cluster_name = var.eks_cluster_name
} 