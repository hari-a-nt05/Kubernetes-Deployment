output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_id
}
