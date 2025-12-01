provider "aws" {
  region = var.region
}


# Ensure global name uniqueness (S3 bucket names are global)
resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  bucket_name = "week1-example-${var.learner_id}-${random_id.suffix.hex}"
  index_html  = <<HTML
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>S3 Test</title></head>
<body style="font-family:Arial;text-align:center;margin-top:10vh">
  <h1>✅ S3 Public Read Test</h1>
  <p>Bucket: <strong>${local.bucket_name}</strong></p>
  <p>Region: <strong>${var.region}</strong></p>
</body>
</html>
HTML
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Project = "S3 Public Read Demo"
    Owner   = var.learner_id
  }
}

# 2) Modern best practice: disable ACLs entirely (BucketOwnerEnforced)
#    This turns on "Object Ownership: Bucket owner enforced" so ACLs are ignored.
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# 3) Public access block: keep ACL blocks ON (we don't use ACLs),
#    but ALLOW public bucket policies (the minimum needed for a public-read website).
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true  # OK because we disabled ACLs
  ignore_public_acls      = true  # OK because we disabled ACLs
  block_public_policy     = false # MUST be false to allow a public bucket policy
  restrict_public_buckets = false # MUST be false to allow Principal="*"
}

# 4) Bucket policy granting public read of OBJECTS only (not the bucket)
data "aws_iam_policy_document" "public_read" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.public_read.json

  depends_on = [
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket_ownership_controls.this
  ]
}

# 5) (Optional) Enable static website hosting
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# 6) Upload a minimal index.html so you can test immediately
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.this.id
  key          = "index.html"
  content      = local.index_html
  content_type = "text/html"
}

# Optional error page
resource "aws_s3_object" "error" {
  count        = var.enable_website ? 1 : 0
  bucket       = aws_s3_bucket.this.id
  key          = "error.html"
  content      = "<h1>Not Found</h1>"
  content_type = "text/html"
}