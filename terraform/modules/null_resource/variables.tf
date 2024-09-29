variable "instance_id" {
  description = "The ID of the EC2 instance"
  type        = string
}

variable "inventory" {
  description = "Path to the Ansible hosts inventory file"
}

variable "playbook" {
  description = "Path to the Ansible playbook"
}

variable "private_key_path" {
  description = "Path to the Ansible Key"
}

variable "public_ip" {
  description = "The public IP address of the EC2 instance"
  type        = string
}
