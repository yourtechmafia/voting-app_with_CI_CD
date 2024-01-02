data "aws_iam_openid_connect_provider" "oidc_provider" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
