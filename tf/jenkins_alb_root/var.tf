variable "name" {
  type = string
  default = "jenkins"
}

variable "instance_type" {
  description = "Instance type for Jenkins EC2 instance"
  type        = string
  default     = "t3.small"
}

variable "ami" {
  description = "AMI ID for Jenkins EC2 instance"
  type        = string
  default     = "ami-05a860b39d42d1bb5"
}

variable "security_group_name" {
  description = "Security group name for Jenkins"
  type        = string
  default     = "jenkins-sg"
}

variable "jenkins_web_ui_port" {
  description = "Port for Jenkins Web UI"
  type        = number
  default     = 8080
}

variable "web_ui_cidr_blocks" {
  description = "CIDR blocks allowed to access Jenkins Web UI"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Replace with restricted CIDR ranges if needed
}

variable "instance_name" {
  description = "Name for Jenkins EC2 instance"
  type        = string
  default     = "jenkins-master"
}

variable "ingress_rules" {
  description = "Dynamic list of ingress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow access to Jenkins Web UI"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow agent connections to Jenkins master"
      from_port   = 50000
      to_port     = 50000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow SSH access to agents"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "egress_rules" {
  description = "Dynamic list of egress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow SSH communication to agents"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow communication to JNLP agents"
      from_port   = 50000
      to_port     = 50000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
