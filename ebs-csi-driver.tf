data "tls_certificate" "oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# EKS addon
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.32.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn

  # ensure nodes exist before we deploy the add‑on
  depends_on = [aws_eks_node_group.default]

  resolve_conflicts_on_create = "OVERWRITE"

}


