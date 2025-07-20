resource "aws_eks_cluster" "main" {
  name = "main"


  role_arn = aws_iam_role.cluster.arn
  version  = "1.32"

  vpc_config {
    subnet_ids = [
      aws_subnet.public[0].id,
      aws_subnet.public[1].id,
      aws_subnet.public[2].id,
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

