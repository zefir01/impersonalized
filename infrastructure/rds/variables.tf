variable "vpc_id" {
  type = string
}
variable "stack" {
  type = string
}
variable "db_subnet_group_name" {
  type = string
}
variable "domain" {
  type = string
}
variable "instance_type" {
  type = string
  default = "db.t3.small"
}
variable "access_cidr" {
  type = string
  default = "0.0.0.0/0"
}
variable "publicly_accessible" {
  type = bool
  default = true
}
variable "deletion_protection" {
  type = bool
  default = false
}
variable "max_space" {
  type = number
  default = 1000
}