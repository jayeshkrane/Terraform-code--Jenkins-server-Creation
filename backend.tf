terraform {
  backend "s3" {
    bucket = "tech-data-app"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
  }
}
