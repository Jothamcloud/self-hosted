variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "ingress_ports" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
}

variable "security_name" {
  description = "Name of the security group"
  type        = string
}

variable "security_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}
