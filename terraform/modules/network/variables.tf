variable "private_subnets" {
  type    = any
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnets" {
  type    = any
  default = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "name" {
  type    = any
  default = "mon-vpc"
}

variable "cidr" {
  type    = any
  default = "10.0.0.0/16"
}