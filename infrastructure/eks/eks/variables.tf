### network
variable "subnets" {
  description = "The list of subnet IDs to deploy your EKS cluster"
  type        = list(string)
  default     = null
}

### kubernetes cluster
variable "kubernetes_version" {
  description = "The target version of kubernetes"
  type        = string
  default     = "1.22"
}

### feature
variable "enabled_cluster_log_types" {
  description = "A list of the desired control plane logging to enable"
  type        = list(string)
  default     = []
}

variable "enable_ssm" {
  description = "Allow ssh access using session manager"
  type        = bool
  default     = false
}

### security
variable "policy_arns" {
  description = "A list of policy ARNs to attach the node groups role"
  type        = list(string)
  default     = []
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}

variable "cert_email" {
  type    = string
  default = "d@blablabla.network"
}

variable "vpc_id" {
  type = string
}
variable "region" {
  type = string
}

variable "enable_prefixes" {
  type = bool
  default = true
}

variable "main_instance_type" {
  type = string
}
variable "main_instance_count" {
  type = number
}

variable "stack" {
  type = string
}
variable "partition" {
  type = string
}
variable "partition_dns_suffix" {
  type = string
}
variable "account_id" {
  type = string
}
variable "github_role_arn" {
  type = string
}