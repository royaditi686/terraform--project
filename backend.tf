terraform {
  backend "s3" {
    bucket = "young-minds-aditianaya-bucket"
    key = "main"
    region = "us-east-1"
    dynamodb_table = "yg-aditi-2026"
  }
}