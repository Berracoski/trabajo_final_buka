## instancia ubuntu bastion
resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ami.ubuntu_2404.id
  instance_type               = "t2.micro"
  key_name                    = "pin"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ubuntu.id]
  subnet_id                   = aws_subnet.public[0].id
  user_data                   = file("user_data.sh")
  iam_instance_profile        = aws_iam_instance_profile.ubuntu_admin.name
  tags = {
    Name = "ubuntu-bastion"
  }
}

# Security group bastion con conexion ssh

resource "aws_security_group" "ubuntu" {
  name        = "ubuntu"
  description = "Allow TCP 22"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creacion rol administrador

resource "aws_iam_role" "ubuntu_admin" {
  name = "ubuntu-admin"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "administrador_attach" {
  role       = aws_iam_role.ubuntu_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "ubuntu_admin" {
  name = "ubuntu-admin"
  role = aws_iam_role.ubuntu_admin.name
}