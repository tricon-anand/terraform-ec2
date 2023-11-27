terraform {
  backend "s3" {
    bucket = "tf-anand-state-bucket"
    region = "us-east-1"
    key="terraform.tfstate"
  }
}