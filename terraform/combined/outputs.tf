output "ecr_repository_url" {
  value = try(module.ecr.ecr_repository_url, "")
}

output "rds_endpoint" {
  value = try(module.rds.rds_endpoint, "")
}

output "eks_cluster_name" {
  value = try(module.eks.cluster_id, module.eks.cluster_name)
}
