output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_id" {
  value = aws_eks_cluster.cluster.id
}