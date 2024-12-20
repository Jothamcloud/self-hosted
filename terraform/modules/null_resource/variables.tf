variable "instance_id" {
  description = "The ID of the EC2 instance"
  type        = string
}

# variable "inventory" {
#   description = "Path to the Ansible hosts inventory file"
# }

# variable "playbook" {
#   description = "Path to the Ansible playbook"
# }

# variable "private_key_path" {
#   description = "Path to the Ansible Key"
# }

variable "public_ip" {
  description = "The public IP address of the EC2 instance"
  type        = string
}

# variable "domain_name" {
#   description = "The fully qualified donaim name for route53"
#   type        = string
# }

variable "ssh_port" {
  description = "The port number for SSH access to the server"
  type        = number
}

variable "jenkins_fqdn" {
  description = ""
  type        = string
}

variable "grafana_fqdn" {
  description = ""
  type        = string
}

variable "prometheus_fqdn" {
  description = ""
  type        = string
}

variable "vault_fqdn" {
  description = ""
  type        = string
}

variable "gitea_fqdn" {
  description = ""
  type        = string
}

variable "s3_access_key" {
  type = string
}

variable "s3_secret_key" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "restore" {
  type = string
}

variable "init" {
  type = string
}

variable "aws_kms_key_id" {
  type = string
}

variable "aws_region" {
  type        = string
}

variable "worker_public_ip" {
  description = "The public IP address of the EC2 instance"
  type        = string
}