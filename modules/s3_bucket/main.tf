resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.bucket
  
  tags = {
    Name = "Terraform State Bucket"
  }
}