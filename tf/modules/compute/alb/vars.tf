variable "vpc_id" {
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
}

variable "name" {
  type        = string
}

variable "load_balancer_type" {
  description = "load balancer (application or network)"
  type        = string
}

variable "ingress_from_port" {
  description = "starting port for ingress traffic"
  type        = number
}

variable "ingress_to_port" {
  description = "endport for ingress traffic"
  type        = number
}

variable "target_group_port" {
  type        = number
}

variable "protocol" {
  description = "protocol for the load balancer(HTTP or TCP)"
  type        = string
}

variable "health_check_port" {
  description = "port for the health check"
  type        = number
}

variable "listener_port" {
  type        = number
}

variable "instance_id" {
  type        = string
}
