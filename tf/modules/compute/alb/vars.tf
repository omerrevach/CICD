variable "vpc_id" {
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
}

variable "jenkins_instance_id" {
  type        = string
}

variable "name" {
  type        = string
}
