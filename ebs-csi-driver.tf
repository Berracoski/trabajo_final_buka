resource "aws_eks_addon" "this" {

  cluster_name = aws_eks_cluster.main.name
  addon_name   = "aws-ebs-csi-driver"

  addon_version               = "v1.32.0-eksbuild.1"
  configuration_values        = null
  preserve                    = true
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.ebs_csi_driver.arn

  depends_on = [
    aws_eks_node_group.default
  ]

}
