provider "aws" {
  region = "eu-central-1"
}

# 1. Create S3 bucket
resource "aws_s3_bucket" "devops_bucket" {
  bucket = "devops-study-bucket-12346"
}

# 2. Create IAM user
resource "aws_iam_user" "devops_student_t" {
  name = "devops-student_t"
}

# 3. Custom policy (bucket only)
resource "aws_iam_policy" "bucket_access" {
  name        = "DevOpsBucketAccess_t"
  description = "Full access to one S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:*"
      Resource = [
        "arn:aws:s3:::${aws_s3_bucket.devops_bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.devops_bucket.bucket}/*"
      ]
    }]
  })
}

# 4. Attach policy to user
resource "aws_iam_user_policy_attachment" "student_bucket_attach" {
  user       = aws_iam_user.devops_student_t.name
  policy_arn = aws_iam_policy.bucket_access.arn
}

