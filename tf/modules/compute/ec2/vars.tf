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
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script for EC2 instance initialization"
  type        = string
  default     = null
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "ingress_from_port" {
  description = "Ingress rule start port"
  type        = number
}

variable "ingress_to_port" {
  description = "Ingress rule end port"
  type        = number
}

variable "ingress_protocol" {
  description = "Ingress rule protocol"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks for ingress traffic"
  type        = list(string)
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}
