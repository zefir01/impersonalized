variable "stack" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "region" {
  type = string
}
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
variable "subnet" {
  type = string
}