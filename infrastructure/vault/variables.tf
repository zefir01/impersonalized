variable "stack" {
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
variable "tags" {
  type = map(string)
  default = {}
}