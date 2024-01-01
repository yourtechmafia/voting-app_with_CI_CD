resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name            = aws_eks_cluster.eks.name
  addon_name              = "ebs-csi-driver"
  addon_version           = "v1.2.0"  // Replace with the required version
  service_account_role_arn = aws_iam_role.ebs_csi_role.arn
}
