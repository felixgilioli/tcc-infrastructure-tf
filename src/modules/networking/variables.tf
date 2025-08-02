variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks para as subnets públicas"
  type        = list(string)
}

variable "eks_private_subnets" {
  description = "CIDR blocks para as subnets privadas do EKS"
  type        = list(string)
}

variable "rds_private_subnets" {
  description = "CIDR blocks para as subnets privadas do RDS"
  type        = list(string)
}

variable "availability_zones" {
  description = "Zonas de disponibilidade para as subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Tags padrão para todos os recursos"
  type        = map(string)
} 