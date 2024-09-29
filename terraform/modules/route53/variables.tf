variable "zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
}

variable "domain_name" {
  description = "Domain name to create the DNS record for"
  type        = string
}

variable "public_ip" {
  description = "Public IP of the EC2 instance"
  type        = string
}
