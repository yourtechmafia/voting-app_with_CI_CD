data "aws_iam_openid_connect_provider" "existing_oidc_provider" {
  arn = "arn:aws:iam::446319600542:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/5D451DCE6B903B90F76ECE821CA309A0"  //  Replace with your OIDC provider's ARN
}
