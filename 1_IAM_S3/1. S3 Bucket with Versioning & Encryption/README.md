# Example 1 – S3 Bucket with Versioning & Encryption

🎯 **Goal**  
Learn how to protect data in S3 using **versioning** (undelete files) and **SSE-S3 encryption** (AES-256, free).

---

## 🔹 Theory
- **Versioning**: keeps old object versions → restore deleted/overwritten files.
- **SSE-S3 encryption**: AWS encrypts objects at rest automatically, no extra cost.

---

## 🔹 AWS Console (GUI)
1. Go to **S3 → Create bucket** → name: `week1-example1-<id>`.
2. Enable **Bucket versioning**.
3. Enable **Default encryption → SSE-S3 (AES-256)**.
4. Upload a file (`hello.txt`).
5. Upload another file with the same name → check **Versions** tab.

---

## 🔹 AWS CLI
```bash
# Create bucket
aws s3 mb s3://week1-example1-123 --region eu-central-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket week1-example1-123 \
  --versioning-configuration Status=Enabled

# Enable default encryption
aws s3api put-bucket-encryption \
  --bucket week1-example1-123 \
  --server-side-encryption-configuration \
    '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# Upload and overwrite file
echo "first version" > hello.txt
aws s3 cp hello.txt s3://week1-example1-123/
echo "second version" > hello.txt
aws s3 cp hello.txt s3://week1-example1-123/

# List object versions
aws s3api list-object-versions --bucket week1-example1-123
````

---

## 🔹 Terraform

Use `main.tf` with:

* `aws_s3_bucket`
* `aws_s3_bucket_versioning`
* `aws_s3_bucket_server_side_encryption_configuration`

Run:

```bash
terraform init
terraform apply -auto-approve
```

---

## 🔹 Destroy

```bash
# CLI
aws s3 rb s3://week1-example1-123 --force

# Terraform
terraform destroy -auto-approve
```