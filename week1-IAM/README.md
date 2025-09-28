# 📖 Week 1 – IAM (using S3 only)

---

## 🔹 Step 1 – Create S3 Bucket (Console or CLI)

**Console way:**

* S3 → Create bucket → Name: `devops-study-bucket-<random>` → Region: `eu-central-1`.
* Leave defaults (block public access).

**CLI way:**

```bash
aws s3 mb s3://devops-study-bucket-12345 --region eu-central-1
```

---

## 🔹 Step 2 – Create IAM User (Console)

1. IAM → Users → Add user → Name: `devops-student`.
2. Access type: **Programmatic access** (CLI use).
3. Attach policy: `AmazonS3ReadOnlyAccess`.
4. Save **Access Key ID** and **Secret Key**.

---

## 🔹 Step 3 – Configure AWS CLI for New User

```bash
aws configure --profile student
```

Test:

```bash
aws s3 ls --profile student
```

→ should show bucket list.

Try write (should **fail**):

```bash
echo "test" > test.txt
aws s3 cp test.txt s3://devops-study-bucket-12345/ --profile student
```

---

## 🔹 Step 4 – Create Custom Policy (Read+Write but Only to One Bucket)

JSON policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": [
        "arn:aws:s3:::devops-study-bucket-12345",
        "arn:aws:s3:::devops-study-bucket-12345/*"
      ]
    }
  ]
}
```

* Save as `bucket-access.json`.
* Console: IAM → Policies → Create → JSON → paste.
* Name: `DevOpsBucketAccess`.
* Attach to `devops-student`.

Test again:

```bash
aws s3 cp test.txt s3://devops-study-bucket-12345/ --profile student
aws s3 ls s3://devops-study-bucket-12345/ --profile student
```

✅ should now work.

---

# 🧩 Terraform Version – IAM + S3

`main.tf`:

```hcl
provider "aws" {
  region = "eu-central-1"
}

# 1. Create S3 bucket
resource "aws_s3_bucket" "devops_bucket" {
  bucket = "devops-study-bucket-12345"
}

# 2. Create IAM user
resource "aws_iam_user" "devops_student" {
  name = "devops-student"
}

# 3. Custom policy (bucket only)
resource "aws_iam_policy" "bucket_access" {
  name        = "DevOpsBucketAccess"
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
  user       = aws_iam_user.devops_student.name
  policy_arn = aws_iam_policy.bucket_access.arn
}
```

Deploy:

```bash
terraform init
terraform apply -auto-approve
```

Test with new user:

```bash
aws configure --profile student
aws s3 cp test.txt s3://devops-study-bucket-12345/ --profile student
```

