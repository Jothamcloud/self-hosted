variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "instance_tags" {
  description = "Additional tags for the EC2 instance"
  type        = map(string)
  default     = {}
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

variable "ingress_ports" {
  description = "List of ingress ports and protocols"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
}

variable "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "Domain name to create the DNS record for"
  type        = string
}

variable "ssh_port" {
  description = "The port number for SSH access to the server"
  type        = number
}

variable "s3_bucket_name" {
  type = string
}

variable "s3_access_key" {
  type =string
}

variable "s3_secret_key" {
  type = string
}

variable "restore" {
  type = string
}