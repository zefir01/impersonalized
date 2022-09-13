variable "oidc_url" {
  type = string
}
variable "oidc_arn" {
  type = string
}
variable "replicas" {
  type = number
}
### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  type = string
}
variable "region" {
  type = string
}

variable "stack" {
  type = string
}


variable "domain" {
  type = string
}
variable "amp_endpoint" {
  type = string
}
variable "service_name" {
  type = string
  default = "grafana"
}