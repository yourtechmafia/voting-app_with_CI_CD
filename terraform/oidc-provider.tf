data "external" "oidc_thumbprint" {
  program = ["bash", "${path.module}/get-thumbprint.sh", aws_eks_cluster.eks.identity[0].oidc[0].issuer]
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.oidc_thumbprint.result["thumbprint"]]
}
