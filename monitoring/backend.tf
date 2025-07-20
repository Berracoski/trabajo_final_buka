terraform {
  backend "s3" {
    bucket       = "proyecto-final-g8-backend"
    region       = "us-east-1"
    key          = "monitoring.tfstate"
    use_lockfile = true
  }
}
