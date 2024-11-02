provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  count = 1

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
}
}

module "ec2_instance" {
  source              = "./modules/ec2"
  subnet_id           = data.aws_subnet.default[0].id 
  instance_type       = var.instance_type
  security_group_ids   = [module.security_group.security_group_id]
  key_name            = var.key_name
  instance_name       = var.instance_name
  ami                 = var.ami


  user_data = templatefile("./userdata.yml", {
    public_key = file("./ansible_key.pub"),
    ssh_port   = var.ssh_port
  }) 
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id          = data.aws_vpc.default.id
  ingress_ports   = var.ingress_ports
  security_name   = var.security_name
  security_tags   = var.security_tags
  ssh_port       = var.ssh_port
}

module "route53" {
  source     = "./modules/route53"
  zone_id    = var.route53_zone_id
  domain_name     = var.domain_name
  public_ip   = module.ec2_instance.public_ip
}

module "null_resource" {
  source         = "./modules/null_resource"
  instance_id    = module.ec2_instance.instance_id  
  inventory      = "./ansible/hosts"
  playbook       = "./ansible/playbook.yml"
  private_key_path = "./ansible_key"  
  public_ip         = module.ec2_instance.public_ip
  jenkins_fqdn = module.route53.jenkins_fqdn
  grafana_fqdn = module.route53.grafana_fqdn
  prometheus_fqdn = module.route53.prometheus_fqdn
  vault_fqdn  = module.route53.vault_fqdn
  gitea_fqdn = module.route53.gitea_fqdn
  ssh_port       = var.ssh_port
  s3_bucket_name  = var.s3_bucket_name
  s3_access_key = var.s3_access_key
  s3_secret_key = var.s3_secret_key
  restore   = var.restore
  init = var.init
  aws_kms_key_id = var.aws_kms_key_id
  aws_region = var.aws_region
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "Public IP of the EC2 instance "
  value       = module.ec2_instance.public_ip
}

output "jenkins_fqdn" {
  value = module.route53.jenkins_fqdn
}

output "grafana_fqdn" {
  value = module.route53.grafana_fqdn
}

output "prometheus_fqdn" {
  value = module.route53.prometheus_fqdn
}

output "vault_fqdn" {
  value = module.route53.vault_fqdn
}

output "gitea_fqdn" {
  value = module.route53.gitea_fqdn
}