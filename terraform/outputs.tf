output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.myvpc.id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.Mysubnet01.id, aws_subnet.Mysubnet02.id]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.myigw.id
}

output "eks_cluster_id" {
  description = "The ID of the EKS Cluster"
  value       = aws_eks_cluster.eks.id
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS Cluster"
  value       = aws_eks_cluster.eks.arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with your cluster"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_node_group_id" {
  description = "The ID of the EKS Node Group"
  value       = aws_eks_node_group.node-grp.id
}
