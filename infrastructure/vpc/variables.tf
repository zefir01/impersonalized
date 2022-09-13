variable "cluster_name" {
  type = string
}
variable "enable_endpoints" {
  type    = bool
  default = false
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}

variable "stack" {
  type = string
}
variable "public_db_subnets" {
  type = bool
  default = true
}