variable "name" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
}

variable "load_balancer_type" {
  description = "(application or network)"
  type        = string
}

variable "protocol" {
  description = "protocoltarget groups and listener (HTTP or TCP)"
  type        = string
}

variable "ingress_from_port" {
  type        = number
}

variable "ingress_to_port" {
  type        = number
}

variable "target_groups" {
  type = map(object({
    port              = number
    protocol          = string
    health_check_path = string
    health_check_port = number
    instance_id       = string
    target_group_port = number
  }))
}

variable "listeners" {
  type = map(object({
    port              = number
    protocol          = string
    target_group_key  = string
  }))
}
