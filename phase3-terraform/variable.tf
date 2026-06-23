variable "region" {
  default = "ap-south-1"
}

variable "key_name" {
  default = "awsb12key"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}