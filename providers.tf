# Provider aws
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Provider kubernetes 
# TODO: Editar config path y config context
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

# Provider helm
#TODO: editar kubernetes y config path
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
