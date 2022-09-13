variable "stack" {
  type = string
}
variable "domain" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "oidc_url" {
  type = string
}
variable "oidc_arn" {
  type = string
}
variable "cluster_endpoint" {
  type = string
}
variable "cluster_ca" {
  type = string
}
variable "cluster_worker_iam_role_name" {
  type = string
}
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
variable "replicas" {
  type = number
}
variable "region" {
  type = string
}
variable "karpenter_instance_type" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "crossplane_irsa_arn" {
  type = string
}
variable "blablabla_db_url" {
  type = string
}
variable "blablabla_front_domain" {
  type = string
}
variable "blablabla_back_domain" {
  type = string
}
variable "env" {
  type = string
}

variable "metabase_user" {
  type = string
}
variable "metabase_password" {
  type = string
}
variable "metabase_db" {
  type = string
}
variable "metabase_db_host" {
  type = string
}

variable "polkadot_db_user" {
  type = string
}
variable "polkadot_db_pass" {
  type = string
}
variable "polkadot_db_host" {
  type = string
}
variable "polkadot_db_name" {
  type = string
}

variable "squid_polkadot_db_user" {
  type = string
}
variable "squid_polkadot_db_pass" {
  type = string
}
variable "squid_polkadot_db_host" {
  type = string
}
variable "squid_polkadot_db_name" {
  type = string
}