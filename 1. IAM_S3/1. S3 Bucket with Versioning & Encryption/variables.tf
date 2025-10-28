variable "bucket_name" {
  description = "Globbaly unique bucket name"
  type        = string
}

variable "user_name" {
  description = "Existing IAM user name to attach the policy to"
  type        = string
}

variable "policy_arn" {
  description = "ARN of the existing IAM policy to attach"
  type        = string
}