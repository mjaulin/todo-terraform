variable "region" {
  description = "AWS region"
  default     = "eu-west-1"  # Ireland
}

variable "profile" {
  description = "AWS Profile set in aws config file"
  default     = "onepoint-lab"
}

variable "availability_zones" {
  description = "AWS availability zones"
  type = "list"
  default = [
    "eu-west-1a",
    "eu-west-1b"
  ]
}

variable "cidr_block" {
  description = "CIDR block of the VPC"
  default     = "10.0.0.0/23"
}

variable "version" {
  default = "latest"
}

locals {
  default_tags = {
    Author      = "m.jaulin"
    Project     = "meetup-aws"
    Provisioner = "terraform"
  }
}