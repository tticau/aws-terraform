# 📦 AWS S3 Static Website with Terraform
[![Terraform](https://img.shields.io/badge/Terraform-%F0%9F%94%A7%20IaC-623CE4)](https://developer.hashicorp.com/terraform)
[![AWS](https://img.shields.io/badge/AWS-S3-orange)](https://aws.amazon.com/s3/)
[![Graph](https://img.shields.io/badge/Graph-cytoscape%20HTML-blue)](#-visualizing-the-terraform-graph)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> Opinionated, lab‑friendly S3 static site with policy‑based public read, no ACLs, and two graphing paths: pretty HTML (Docker beautifier) and raw DOT/JSON.

---

## ✨ What this Terraform does (TL;DR)
- Creates a globally unique **S3 bucket** (uses a random suffix)
- Enforces **BucketOwnerEnforced** ownership controls (**ACLs disabled**)
- Allows **public object reads** via a **bucket policy**, not ACLs
- **Optionally** enables **S3 Static Website Hosting** (index + error pages)
- Uploads a simple `index.html` (and `error.html` if website hosting is on)
- Exposes useful **outputs**: bucket name/ARN, website endpoint, object URL

---

## 🧩 Resource breakdown (by category)
<details>
<summary><strong>Providers & versions</strong></summary>

- Locks Terraform / provider versions (reproducibility)
- AWS provider uses `var.region`
</details>

<details>
<summary><strong>Uniqueness helper</strong></summary>

- `random_id.suffix` — ensures a globally unique S3 bucket name
</details>

<details>
<summary><strong>S3 core</strong></summary>

- `aws_s3_bucket.this` — creates the S3 bucket (lab‑friendly `force_destroy`)
- `aws_s3_bucket_ownership_controls.this` — sets `BucketOwnerEnforced` (no ACLs)
- `aws_s3_bucket_public_access_block.this` — blocks ACLs but allows public **policy**
- `data.aws_iam_policy_document.public_read` — anonymous `s3:GetObject` on objects
- `aws_s3_bucket_policy.this` — attaches the policy
- `aws_s3_bucket_website_configuration.this` — static website hosting (conditional)
</details>

<details>
<summary><strong>Content</strong></summary>

- `aws_s3_object.index` — uploads inline `index.html`
- `aws_s3_object.error` — uploads `error.html` if hosting is enabled
</details>

<details>
<summary><strong>Variables & Outputs</strong></summary>

- Vars: `region`, `learner_id` (required), `enable_website` (bool), `force_destroy` (bool)
- Outputs: bucket name/ARN, website endpoint (if enabled), `index.html` REST URL
</details>

---

## 🚀 Usage
```bash
# authenticate (env, SSO, or profile)
export AWS_PROFILE=your-profile

terraform init
terraform apply -auto-approve -var="learner_id=tudor"
terraform output

# destroy when done
terraform destroy -auto-approve -var="learner_id=tudor"
```

> Default region: `eu-central-1`. Toggle S3 website hosting via `enable_website`.

---

## 📊 Visualizing the Terraform graph

### Method 1 — Interactive HTML (Docker + beautifier) ✅
Generates an **interactive Cytoscape HTML** file (`config1.html`) you can open locally:

```bash
terraform graph -type=plan | docker run --rm -i   --name terraform-graph-beautifier   ghcr.io/pcasteran/terraform-graph-beautifier:latest-linux   --output-type=cyto-html   > config1.html
```

- Use *Collapse all / Expand all / Run layout* inside the viewer
- `-type=plan` trims the graph to resources in the current **plan** (cleaner)

### Method 2 — Raw graph (DOT / JSON)
```bash
# Default DOT
terraform graph > graph.dot

# Optional: render with Graphviz
dot -Tpng graph.dot -o graph.png

# Machine-readable JSON (Terraform 1.5+)
terraform graph -json > graph.json
```
> ⚠️ If you run `terraform graph > graph.json` **without** `-json`, the contents are still **DOT** (mislabeled). Rename to `.dot` for clarity.

---

## 🧪 Make targets
```makefile
init:
	terraform init

apply:
	terraform apply -auto-approve -var="learner_id?=tudor"

destroy:
	terraform destroy -auto-approve -var="learner_id?=tudor"

graph-html:
	terraform graph -type=plan | docker run --rm -i ghcr.io/pcasteran/terraform-graph-beautifier:latest-linux --output-type=cyto-html > config1.html

graph-dot:
	terraform graph -type=plan > plan.dot

graph-json:
	terraform graph -type=plan -json > plan.json
```

---

## 🤖 GitHub Actions (artifact: HTML + DOT + JSON)
This workflow renders the graph on each push and uploads artifacts.

- Uses Dockerized beautifier for `config1.html`
- Produces both `plan.dot` and `plan.json`
- Does **not** require AWS creds; it runs `terraform init -backend=false`

```yaml
name: terraform-graph
on:
  push:
  workflow_dispatch:

jobs:
  graph:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.9.5

      - name: Terraform init (no backend)
        run: terraform init -backend=false -input=false

      - name: DOT plan graph
        run: terraform graph -type=plan > plan.dot

      - name: JSON plan graph
        run: terraform graph -type=plan -json > plan.json

      - name: HTML graph (beautifier)
        run: |
          terraform graph -type=plan | docker run --rm -i             ghcr.io/pcasteran/terraform-graph-beautifier:latest-linux             --output-type=cyto-html             > config1.html

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: terraform-graphs
          path: |
            config1.html
            plan.dot
            plan.json
```

> If your org blocks Docker in Actions, swap the HTML step with a Graphviz render (`dot`) or run the beautifier locally.

---

## 🧠 Why this design (short opinion)
- Policy‑based public access is cleaner than ACLs
- `BucketOwnerEnforced` avoids ACL confusion
- Lab‑friendly `force_destroy=true` — switch off in prod

---

## 📁 Current graph assets in this repo
- `config1.html` — interactive HTML graph you already generated
- `graph.json` — **Ensure you used `-json`** if you expect JSON; otherwise it’s DOT saved as `.json`

---

## 📝 License
MIT
