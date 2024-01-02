resource "aws_eks_cluster" "eks" {
  name     = "votingapp-eks"
  role_arn = aws_iam_role.master.arn
  version  = "1.24" //  Version 1.28 as of this date (Jan 2, 2024) is buggy

  vpc_config {
    subnet_ids = [aws_subnet.Mysubnet01.id, aws_subnet.Mysubnet02.id]
  }

  tags = {
    "Name" = "VotingAppEKS"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}
