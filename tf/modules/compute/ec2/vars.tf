variable "vpc_id" {
  description = "VPC ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  type        = string
}

variable "key_name" {
  type        = string
  default     = null
}

variable "user_data" {
  type        = string
  default     = null
}

variable "security_group_name" {
  type        = string
}

variable "ingress_from_port" {
  type        = number
}

variable "ingress_to_port" {
  type        = number
}

variable "ingress_protocol" {
  type        = string
}

variable "ingress_cidr_blocks" {
  type        = list(string)
}

variable "instance_name" {
  type        = string
}
