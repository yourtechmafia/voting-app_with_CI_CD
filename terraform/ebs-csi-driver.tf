resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name            = aws_eks_cluster.eks.name
  addon_name              = "aws-ebs-csi-driver"
  addon_version           = "v1.5.2-eksbuild.1"  // Replace with the required version
  service_account_role_arn = aws_iam_role.ebs_csi_role.arn
}
