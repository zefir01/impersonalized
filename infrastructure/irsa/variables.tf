variable "oidc_url" {
  type = string
}
variable "oidc_arn" {
  type = string
}
variable "name" {
  type = string
}
variable "namespace" {
  type = string
}
variable "serviceaccount" {
  type = string
}
variable "policy_arns" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
variable "cluster_name" {
  type = string
}
variable "sa_wildcard" {
  type = bool
  default = false
}