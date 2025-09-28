# Example 3 – Pre-Signed URLs for Temporary Access

🎯 **Goal**  
Learn how to share private S3 objects securely using **time-limited links**.

---

## 🔹 Theory
- **Pre-signed URL** = temporary signed link using your credentials.
- Valid for seconds → hours, after which it expires.
- Lets you share private files without making the bucket public.

---

## 🔹 AWS Console (GUI)
⚠️ AWS Console does not generate pre-signed URLs.  
They must be created with **CLI** or an SDK (Python, Go, Node.js, etc.).

---

## 🔹 AWS CLI
```bash
# Create private bucket
aws s3 mb s3://week1-example3-123 --region eu-central-1

# Upload file (private by default)
echo "secret report" > report.txt
aws s3 cp report.txt s3://week1-example3-123/

# Generate pre-signed URL valid 5 minutes
aws s3 presign s3://week1-example3-123/report.txt --expires-in 300
````

Open the generated link in browser → works only until expiry.

---

## 🔹 Terraform

Use `main.tf` with:

* `aws_s3_bucket`
* `aws_s3_bucket_acl` set to `private`.

⚠️ Pre-signed URLs cannot be managed in Terraform, generate them with CLI after creating bucket.

---

## 🔹 Destroy

```bash
# CLI
aws s3 rb s3://week1-example3-123 --force

# Terraform
terraform destroy -auto-approve
```