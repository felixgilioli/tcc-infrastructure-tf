
variable "region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks para as subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "eks_private_subnets" {
  description = "CIDR blocks para as subnets privadas do EKS"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "hml-webapp-eks-cluster"
}

variable "tags" {
  description = "Tags padrão para todos os recursos"
  type        = map(string)
  default = {
    Environment = "homologation"
    Project     = "webapp"
    ManagedBy   = "terraform"
    Owner       = "devops-team"
  }
}
