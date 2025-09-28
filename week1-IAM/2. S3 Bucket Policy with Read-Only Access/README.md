# Example 2 – S3 Bucket Policy with Read-Only Access

🎯 **Goal**  
Learn how to use **bucket policies** to control access. Example: make objects publicly readable.

---

## 🔹 Theory
- **IAM policies** → attach to users.
- **Bucket policies** → attach directly to bucket, apply to all requests.
- ⚠️ Public read is risky, use only for demos/static sites.

---

## 🔹 AWS Console (GUI)
1. Create bucket `week1-example2-<id>`.
2. Go to **Permissions → Bucket policy**.
3. Paste this JSON (public read for all objects):

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::week1-example2-123/*"
  }]
}
````

4. Upload `index.html`.
5. Test in browser:

```
https://week1-example2-123.s3.eu-central-1.amazonaws.com/index.html
```

---

## 🔹 AWS CLI

```bash
# Create bucket
aws s3 mb s3://week1-example2-123 --region eu-central-1

# Attach bucket policy
cat > policy.json <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Principal":"*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::week1-example2-123/*"]
  }]
}
EOF

aws s3api put-bucket-policy --bucket week1-example2-123 --policy file://policy.json

# Upload file
echo "<h1>Hello World</h1>" > index.html
aws s3 cp index.html s3://week1-example2-123/
```

---

## 🔹 Terraform

Use `main.tf` with:

* `aws_s3_bucket`
* `aws_s3_bucket_policy` (jsonencode public-read policy).

Run:

```bash
terraform init
terraform apply -auto-approve
```

---

## 🔹 Destroy

```bash
# CLI
aws s3 rb s3://week1-example2-123 --force

# Terraform
terraform destroy -auto-approve
```