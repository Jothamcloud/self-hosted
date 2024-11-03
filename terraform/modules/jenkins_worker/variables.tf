variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "user_data" {
  type        = string
  description = "User data script for bootstrapping the instance"
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID to launch the EC2 instance in"
  type        = string
}