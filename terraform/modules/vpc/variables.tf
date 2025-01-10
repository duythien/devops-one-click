variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_count" {
  description = "The number of availability zones to use for the VPC"
  type        = number
  default     = 2
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
