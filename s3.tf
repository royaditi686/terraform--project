resource "aws_s3_bucket" "young-minds-aditianaya-bucket" {
  bucket_prefix = var.bucket_prefix
  tags = var.tags
}


resource "aws_s3_bucket_versioning" "young-minds-aditianaya-bucket-versioning" {
  bucket = aws_s3_bucket.young-minds-aditianaya-bucket.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}