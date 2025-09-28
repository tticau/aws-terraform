
## 📅 Month 1 – AWS Core Foundations

### **Week 1 – IAM & Basics**

**Explanation:**

* IAM: users, groups, roles, policies, MFA, least privilege.
* Shared responsibility model.

**Labs:**

* Create an IAM user with programmatic access.
* Create a custom IAM policy and attach to role.
* Configure AWS CLI with that IAM user.

---

### **Week 2 – VPC & Networking**

**Explanation:**

* VPC, subnets, route tables, internet gateway, NAT gateway, security groups, NACLs.

**Labs:**

* Create a VPC with public + private subnet.
* Deploy EC2 in private subnet, connect via bastion host in public subnet.

---

### **Week 3 – Compute & Storage**

**Explanation:**

* EC2 basics (AMI, instance types, key pairs, security groups).
* Storage: S3, EBS basics.

**Labs:**

* Launch EC2, SSH into it, install Nginx.
* Upload files to S3, configure bucket policy for public read.
* Attach & format EBS volume to EC2.

---

### **Week 4 – Monitoring & Logging**

**Explanation:**

* CloudWatch (logs, metrics, alarms).
* CloudTrail (auditing API calls).

**Labs:**

* Create CloudWatch alarm to monitor EC2 CPU.
* Send custom logs from EC2 to CloudWatch.
* Enable CloudTrail and view user actions.

---

## 📅 Month 2 – AWS for Containers & Ops

### **Week 5 – Container Registry & DNS**

**Explanation:**

* ECR basics.
* Route53 basics (DNS zones, records).

**Labs:**

* Push Docker image to ECR.
* Configure Route53 to point domain → EC2 app.

---

### **Week 6 – Load Balancing & Scaling**

**Explanation:**

* Elastic Load Balancers (ALB vs NLB).
* Auto Scaling Groups.

**Labs:**

* Deploy app on two EC2s, load balance with ALB.
* Configure ASG with scaling policy.

---

### **Week 7 – Kubernetes on AWS**

**Explanation:**

* EKS basics: control plane, worker nodes, networking.

**Labs:**

* Deploy EKS cluster using AWS CLI/EKSctl.
* Deploy sample app with LoadBalancer service.

---

### **Week 8 – Security & Secrets**

**Explanation:**

* KMS (encryption).
* Secrets Manager & SSM Parameter Store.

**Labs:**

* Store DB password in Secrets Manager.
* Use IAM role to grant EC2 access to retrieve it.

---

## 📅 Month 3 – Terraform & Automation

### **Week 9 – Terraform Basics**

**Explanation:**

* Providers, resources, variables, outputs.
* Terraform workflow: init → plan → apply → destroy.

**Labs:**

* Write Terraform to deploy EC2 + security group.
* Output instance public IP.

---

### **Week 10 – Networking with Terraform**

**Explanation:**

* VPC, subnets, route tables, IGW, SGs in Terraform.

**Labs:**

* Create VPC + 2 subnets (public/private) using Terraform.
* Deploy EC2 in private subnet with bastion host.

---

### **Week 11 – Containers with Terraform**

**Explanation:**

* ECR + EKS via Terraform.

**Labs:**

* Deploy ECR repo + push image.
* Deploy EKS cluster via Terraform.
* Deploy app on EKS using Terraform Helm provider.

---

### **Week 12 – GitOps & Advanced Terraform**

**Explanation:**

* Remote state (S3 + DynamoDB lock).
* Workspaces for environments.
* CI/CD integration.

**Labs:**

* Configure remote state backend in S3.
* Create staging/prod workspaces.
* Run Terraform plan/apply from GitLab CI pipeline.