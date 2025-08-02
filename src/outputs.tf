

output "vpc_id" {
  value = module.rds.db_instance_endpoint
}

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db_instance_id" {
  value = module.rds.db_instance_id
}

output "db_instance_name" {
  value = module.rds.db_instance_name
}

output "db_instance_username" {
  value = module.rds.db_instance_username
}

output "db_instance_password" {
  value = var.db_password
}

output "k8s_name" {
  value = module.eks.k8s_name
}
