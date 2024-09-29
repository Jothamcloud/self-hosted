variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the EC2 instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with"
  type        = list(string)
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
variable "user_data" {
  type        = string
  description = "User data script for bootstrapping the instance"
}
