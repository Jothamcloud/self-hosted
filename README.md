# Self-Hosted Infrastructure Platform

## Overview
This project automates the deployment of a complete development infrastructure on a single AWS EC2 instance, including source control, CI/CD, secrets management, and comprehensive monitoring. It's designed for small to medium teams needing a cost-effective, self-hosted solution.

## Features
- Source Control Management (Gitea)
- CI/CD Pipeline (Jenkins)
- Secrets Management (HashiCorp Vault)
- Monitoring & Logging (Prometheus, Grafana, Loki)
- Automated Backups with S3
- Security Hardening
- HTTPS with Traefik

## Prerequisites
- AWS Account
- Route53 Hosted Zone
- Domain Name
- Terraform
- Ansible
- AWS CLI

## Quick Start
1. Clone the repository
2. Configure AWS credentials
3. Copy and edit terraform.tfvars:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
4. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform apply
   ```

## Directory Structure
```
terraform/
├── .terraform/                    
├── ansible/
│   ├── roles/
│   │   ├── backups/             
│   │   │   ├── tasks/
│   │   │   │   ├── backup.yml
│   │   │   │   ├── main.yml
│   │   │   │   └── retention.yml
│   │   │   └── templates/
│   │   ├── docker/
│   │   ├── docker-compose/
│   │   ├── essentials/
│   │   ├── monitoring/
│   │   │   ├── handlers/
│   │   │   ├── tasks/
│   │   │   └── templates/
│   │   │       ├── daemon.json.j2
│   │   │       ├── loki-config.yml.j2
│   │   │       └── promtail-config.yml.j2
│   │   ├── restore/
│   │   ├── security/
│   │   ├── utils/
│   │   ├── vault/
│   │   └── vault-init/
│   │       ├── tasks/
│   │       └── templates/
│   ├── ansible.cfg
│   ├── ansible_key
│   ├── ansible_key.pub
│   ├── hosts
│   └── playbook.yml
├── modules/
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── null_resource/
│   ├── route53/
│   └── security_group/
├── .gitignore
├── ansible_key
├── ansible_key.pub
├── backend.tf
├── errored.tfstate
├── main.tf
├── outputs.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
├── userdata.yml
└── variables.tf
```

## Service Access
After deployment, services are available at:
- Gitea: `https://gitea.yourdomain.com`
- Jenkins: `https://jenkins.yourdomain.com`
- Vault: `https://vault.yourdomain.com`
- Grafana: `https://grafana.yourdomain.com`

## Backup and Recovery
- Automated daily backups to S3
- 5-day retention policy
- Restore functionality via Ansible playbook

## Security Features
- SSH hardening
- HTTPS enabled
- Network isolation
- Secrets management
- Regular security updates

## Monitoring
- Host metrics
- Container metrics
- Log aggregation
- Custom dashboards
- Automated alerts

## Contributing
Pull requests are welcome. For major changes, please open an issue first.

## Support
Please open an issue for support.

[Link to detailed blog post coming soon]