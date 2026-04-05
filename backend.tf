terraform {
  backend "s3" {
    bucket = "s3-devops-project-1"
    region = "ap-south-1"
    key = "project/terraform.tfstate"
  }
}
