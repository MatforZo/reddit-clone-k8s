terraform {
  backend "s3" {
    bucket = "mickiewicza43" # Replace with your actual S3 bucket name
    key    = "EKS/terraform.tfstate"
    region = "us-east-1a"
  }
}
