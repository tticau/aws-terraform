# Week 2 – VPC & Networking (Theory Summary)

## 1. VPC – Core Concepts

A **Virtual Private Cloud (VPC)** is an isolated network inside AWS.  
You control:
- IP range (CIDR block)
- Subnets
- Route tables
- Internet/NAT access
- Security (Security Groups, NACLs)
- Endpoints for AWS services

A VPC is simply the container for how your AWS network behaves.

---

## 2. Subnets & IP Structure

### What is a Subnet?
A subnet is a smaller segment of the VPC IP range.  
Subnets separate workloads logically and by availability zone.

### Public vs Private Subnets

| Subnet Type | Route Table Contains | Purpose |
|-------------|----------------------|---------|
| **Public** | `0.0.0.0/0 → Internet Gateway (IGW)` | EC2 that needs inbound/outbound internet |
| **Private** | No IGW route | Internal services (DBs, backends, etc.) |

A subnet becomes **public** only because its route table points to an IGW — not because of its name.

---

## 3. Internet Gateway (IGW)

An **Internet Gateway** is a VPC component that allows:
- Outbound internet access from public subnets  
- Inbound return traffic (e.g., SSH, HTTP)  

It is free and attached at the VPC level.

---

## 4. Route Tables

A route table determines where network traffic goes.

Each route = `destination → target`

Common examples:
- `10.0.0.0/16 → local` (automatic internal routing)
- `0.0.0.0/0 → igw-xxxx` (internet for public subnets)
- `0.0.0.0/0 → nat-xxxx` (private subnets outbound)
- `pl-xxxx → vpce-xxxx` (S3 VPC endpoint)

Every subnet must be associated with exactly **one** route table.

---

## 5. Gateway VPC Endpoint (S3)

A **Gateway Endpoint** creates a private path from your VPC to AWS services:
- S3
- DynamoDB

Purpose:
- Avoids internet/NAT traffic
- Reduces cost
- Improves security

It works by adding a **prefix list route** (`pl-xxxx → vpce-xxxx`) to selected route tables.

Only the subnets whose route tables contain this route can reach S3 privately.

---

## 6. EC2 in the Networking Context

EC2 instances help validate subnet behavior.

### Public EC2 Requirements
- Public subnet
- Public IPv4 address (auto-assign or Elastic IP)
- Route table → IGW
- Security Group allows SSH/HTTP/etc.

### Private EC2 Requirements
- Private subnet
- NO route to IGW
- Optional:
  - SSM for management
  - NAT Gateway *or* S3 endpoint for outbound access

The goal:
- Public EC2 proves internet routing works
- Private EC2 proves isolation + internal routing

---

## 7. Summary

A VPC is your isolated AWS network.  
Public subnets route to an Internet Gateway; private subnets do not.  
Gateway Endpoints allow private access to AWS services without NAT.  
EC2 placement validates your routing and subnet behavior.

Here is a **clean, README-ready exercise set**, with tasks phrased as instructions for the learner.
No step-by-step solutions inside — just the tasks written clearly so you can copy them into your repo.

# Week 2 – VPC & Networking Exercises (GUI)

Complete the following tasks in the AWS Console to build and validate a full VPC networking setup.

---

## **Task 1 — Create Base VPC & Subnets**
**Goal:** Build a custom VPC and divide it into public and private areas.

**Exercises:**
- Create a new VPC with IPv4 CIDR `10.0.0.0/16`
- Create one public subnet (`10.0.1.0/24`)
- Create one private subnet (`10.0.2.0/24`)
- Place both subnets in the same Availability Zone

---

## **Task 2 — Configure Internet Access for Public Subnet**
**Goal:** Make the public subnet truly internet-facing.

**Exercises:**
- Create an Internet Gateway and attach it to your VPC
- Create a route table dedicated to the public subnet
- Add a default route (`0.0.0.0/0`) pointing to the Internet Gateway
- Associate the public subnet with the new route table

---

## **Task 3 — Configure Routing for Private Subnet**
**Goal:** Ensure the private subnet remains isolated from the internet.

**Exercises:**
- Create a route table for the private subnet
- Keep only the local VPC route
- Associate the private subnet with this route table

---

## **Task 4 — Add an S3 Gateway Endpoint**
**Goal:** Allow private subnet resources to reach S3 without internet access.

**Exercises:**
- Create a VPC Gateway Endpoint for S3
- Attach it to the private route table only
- Verify the endpoint automatically adds a prefix-list route for S3

---

## **Task 5 — Launch a Public EC2 Instance**
**Goal:** Test that the public subnet has full internet connectivity.

**Exercises:**
- Launch an EC2 instance in the public subnet
- Ensure Auto-assign Public IP is enabled
- Create a security group allowing SSH from your IP
- Connect via SSH and verify outbound internet access

---

## **Task 6 — Launch a Private EC2 Instance**
**Goal:** Validate private subnet isolation and S3-only access.

**Exercises:**
- Launch an EC2 instance in the private subnet
- Disable public IP assignment
- Create a security group allowing SSH only from the public EC2’s SG
- Connect to the private EC2 by SSHing through the public one
- Verify that:
  - Internet access is blocked
  - S3 access works (via the VPC Endpoint)

---

## **Task 7 — Inspect and Verify Networking in the Console**
**Goal:** Learn how to “read” VPC structure visually.

**Exercises:**
- Review route tables and confirm:
  - Public subnet routes to the IGW
  - Private subnet routes to the S3 prefix list only
- Inspect network interfaces of both EC2 instances
- Verify the S3 Endpoint is attached to the correct route table
- Confirm IP addressing and subnet placement of both EC2 instances

---

## **Completion Criteria**
You should be able to:
- Explain why a subnet is public or private
- Demonstrate internet access from the public subnet only
- Demonstrate S3 access from the private subnet without NAT or IGW
- Navigate and understand all VPC components in the console
