# 📅 Month 1 – AWS Core Foundations (Free-First)

### Week 1 – IAM & S3 Basics

**Explanation**

* IAM: users, groups, roles, policies, MFA, least privilege.
* Shared responsibility model.
* S3 basics: bucket policies vs IAM policies.

**Labs**

* Create an S3 bucket.
* Create IAM user with programmatic access and attach `AmazonS3ReadOnlyAccess`.
* Test with CLI (read works, write fails).
* Create custom policy allowing `s3:*` only on your bucket and attach to user.

---

### Week 2 – VPC & Networking (no EC2)

**Explanation**

* VPC, subnets, route tables, internet gateway (free).
* Difference between public/private subnets.
* Gateway VPC Endpoint for S3 (free).

**Labs**

* Create a VPC with one public + one private subnet.
* Attach Internet Gateway.
* Create VPC Gateway Endpoint for S3.
* Validate via CLI: check routes, describe subnets, and use CLI to access S3 from “private” subnet (conceptual exercise without EC2).

---

### Week 3 – Storage Deep Dive

**Explanation**

* S3 versioning, lifecycle rules, encryption.
* EBS (theory only to avoid cost).

**Labs**

* Enable versioning and encryption on S3 bucket.
* Upload a file, delete it, restore from versioning.
* Create lifecycle rule (auto-expire objects after 30 days).
* Generate pre-signed URL to share private file.

---

### Week 4 – Monitoring & Logging

**Explanation**

* CloudWatch basics (log groups, metrics).
* CloudTrail event history (free 90 days).

**Labs**

* Create CloudWatch log group, push a custom event using CLI.
* Enable bucket logging → deliver logs to another S3 bucket.
* View CloudTrail event history for IAM and S3 actions.

---

# 📅 Month 2 – AWS for Security & Ops (Free-First)

### Week 5 – Container Registry & DNS (conceptual + free alternatives)

**Explanation**

* ECR basics (push images).
* Route53 basics (theory only, since hosted zones are billed).

**Labs**

* Create an ECR repo (pennies if used rarely).
* Push/pull a small Docker image.
* (Optional theory) map how Route53 would point DNS → S3 website endpoint (but skip creating hosted zone).

---

### Week 6 – Scaling & Resilience (theory + free)

**Explanation**

* How Auto Scaling works with EC2 (theory).
* Compare ALB vs NLB (theory).
* S3 as a “serverless” scalable service.

**Labs**

* Simulate scaling by uploading many files to S3 and checking durability/access.
* Use S3 static website endpoint to “serve content” without EC2/ALB.

---

### Week 7 – Kubernetes on AWS (conceptual only)

**Explanation**

* EKS architecture: control plane, worker nodes, VPC networking.
* Why EKS is expensive without free tier.

**Labs**

* **Theory exercise**: design an EKS cluster (subnets, nodes, IAM roles).
* (Optional cheap test) use `eksctl create cluster --dry-run` to generate manifest, but don’t apply.

---

### Week 8 – Security & Secrets

**Explanation**

* KMS (free keys: first 20,000 requests).
* SSM Parameter Store (standard tier = free).

**Labs**

* Store DB URL in SSM Parameter Store.
* Attach IAM policy allowing only `GetParameter` for `/app/dev/*`.
* Test access with IAM user.
* Create a KMS CMK, encrypt/decrypt a string with CLI.

---

# 📅 Month 3 – Terraform & Automation (Free-First)

### Week 9 – Terraform Basics

**Explanation**

* Providers, resources, variables, outputs.
* Terraform workflow.

**Labs**

* Terraform: create S3 bucket + IAM user.
* Output bucket name and user ARN.

---

### Week 10 – Networking with Terraform

**Explanation**

* Build VPC, subnets, IGW with Terraform.
* Modules for reusability.

**Labs**

* Terraform: create `vpc-lite` module (VPC, 2 subnets, IGW, S3 endpoint).
* Output subnet IDs.

---

### Week 11 – Config & Parameters with Terraform

**Explanation**

* Terraform for Parameter Store, KMS.
* Use variables/outputs for secrets.

**Labs**

* Terraform: create SSM parameters (`/app/dev/db_url`).
* Attach IAM policy for read-only access to parameters.
* Output parameter ARN.

---

### Week 12 – GitOps & Advanced Terraform

**Explanation**

* Remote state with Terraform Cloud (free).
* Workspaces (dev/stage/prod).
* CI/CD integration (GitHub Actions free tier).

**Labs**

* Configure Terraform Cloud backend.
* Create two workspaces with different variables.
* GitHub Actions: run `terraform fmt`, `plan`, `tfsec`.
* Scheduled drift detection (`terraform plan` nightly, no apply).

---

✅ **By following this plan, I or you’ll:**

* Learn AWS **fundamentals** without paying for EC2/EKS.
* Practice **IAM, S3, VPC, CloudTrail, Parameter Store, KMS** (all nearly free).
* Master Terraform with free-tier friendly infra (S3, IAM, VPC).
* Get real **GitOps CI/CD** workflows in GitHub.