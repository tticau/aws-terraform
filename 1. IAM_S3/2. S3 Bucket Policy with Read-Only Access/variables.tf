variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-central-1"
}

variable "learner_id" {
  description = "Your unique suffix to keep bucket name unique"
  type        = string
}

variable "enable_website" {
  description = "Enable S3 static website hosting"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow Terraform to delete non-empty buckets"
  type        = bool
  default     = true
}