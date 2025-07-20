# Ultima ami ubuntu 2404
data "aws_ami" "ubuntu_2404" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}

# kubernetes drivers
data "aws_eks_addon_version" "this" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "tls_certificate" "oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}
