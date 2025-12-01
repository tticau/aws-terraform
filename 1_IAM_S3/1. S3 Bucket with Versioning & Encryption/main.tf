terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = "eu-central-1"
}

# 1. Create S3 bucket
resource "aws_s3_bucket" "student_bucket" {
  bucket = var.bucket_name
  tags = {
    Project = "Week1"
    Owner   = "Tudor"
    Env     = "Lab"
  }
}

# 2. block public access
resource "aws_s3_bucket_public_access_block" "block_bucket" {
  bucket                  = aws_s3_bucket.student_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Set default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.student_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.student_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# -------- IAM attachment (existing user + existing policy) --------
# 2. Attach policy to user
resource "aws_iam_user_policy_attachment" "devops_bucket_attach" {
  policy_arn = var.policy_arn
  user       = var.user_name
}
