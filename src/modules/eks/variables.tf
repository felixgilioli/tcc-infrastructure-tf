variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o cluster será criado"
  type        = string
}

variable "eks_version" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "1.31"
}

variable "subnet_ids" {
  description = "IDs das subnets onde o cluster será criado"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs dos security groups para o cluster"
  type        = list(string)
}

variable "node_group_name" {
  description = "Nome do node group"
  type        = string
  default     = "default"
}

variable "node_group_instance_types" {
  description = "Tipos de instância para os nós do EKS"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_desired_size" {
  description = "Número desejado de nós no node group"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Número mínimo de nós no node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Número máximo de nós no node group"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags comuns para todos os recursos"
  type        = map(string)
  default     = {}
} 