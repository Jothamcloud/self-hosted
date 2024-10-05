# AWS Infrastructure Automation with Terraform and Ansible

## Project Overview
This project automates the provisioning of AWS infrastructure using **Terraform** and configures the EC2 instance with **Ansible**. It includes hardened SSH configuration, HTTPS setup with Traefik, and Jenkins deployment using Docker Compose.

## Key Features
- AWS infrastructure provisioning with Terraform
- Hardened SSH configuration with dynamic port
- HTTPS configuration using Traefik and Let's Encrypt
- Jenkins deployment with Docker Compose
- Modular Ansible roles for Docker and Docker Compose

## Directory Structure
```plaintext
terraform/
├── ansible/
│   ├── playbook.yml
│   ├── inventory
│   ├── ansible_keys/
│   └── roles/
│       ├── docker/
│       │   └── tasks/
│       │       └── main.yml
│       └── docker_compose/
│           ├── tasks/
│           │   └── main.yml
│           └── templates/
│               └── docker-compose.yml.j2
├── modules/
│   ├── ec2/
│   ├── null_resources/
│   ├── route53/
│   └── security_group/
├── backend.tf
├── main.tf
├── variables.tf
└── terraform.tfvars
```

## Prerequisites
- Terraform
- AWS CLI configured with your credentials
- Ansible

## Variables
In `terraform.tfvars`, define:
- `aws_region`
- `ami`
- `instance_type`
- `key_name`
- `instance_name`
- `security_name`
- `ingress_ports`
- `route53_zone_id`
- `domain_name`
- `ssh_port` (New variable for custom SSH port)

## Usage
1. Clone the repository
2. Configure AWS CLI
3. Initialize Terraform: `terraform init`
4. Plan deployment: `terraform plan`
5. Apply configuration: `terraform apply`

## SSH Hardening
The project now includes a hardened SSH configuration:
- Root login disabled
- Custom SSH port (defined by `ssh_port` variable)
- Modern ciphers and MACs
- Strict access controls

## HTTPS Configuration with Traefik
Traefik is configured to:
- Automatically obtain and renew Let's Encrypt certificates
- Redirect HTTP traffic to HTTPS
- Act as a reverse proxy for Jenkins

## Jenkins and Traefik Deployment
Jenkins and Traefik are deployed using Docker Compose. The configuration includes:
- Automatic HTTPS setup
- Jenkins accessible through Traefik
- Persistent Jenkins data using Docker volumes

### Docker Compose Configuration
```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443" 
      - "--certificatesresolvers.myresolver.acme.httpchallenge=true"
      - "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
      - "--certificatesresolvers.myresolver.acme.email=your-email@example.com"  
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"  
      - "--entrypoints.web.http.redirections.entryPoint.to=websecure"  
      - "--entrypoints.web.http.redirections.entryPoint.scheme=https"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./letsencrypt:/letsencrypt"

  jenkins:
    image: jenkins/jenkins:lts
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.jenkins.rule=Host(`{{ domain }}`)"  
      - "traefik.http.routers.jenkins.entrypoints=websecure"
      - "traefik.http.services.jenkins.loadbalancer.server.port=8080"
      - "traefik.http.routers.jenkins.tls.certresolver=myresolver"
    environment:
      - JENKINS_OPTS=--httpPort=8080
    volumes:
      - jenkins_home:/var/jenkins_home

volumes:
  jenkins_home:
```

## Ansible Roles
The project now uses modular Ansible roles:

### Docker Role
Installs Docker and Docker Compose.

### Docker Compose Role
Manages the deployment of services using Docker Compose.

## Accessing Jenkins
Once deployed, Jenkins is accessible via HTTPS:
```
https://jenkins.your-domain.com
```

## Security Considerations
- Regularly update the AMI and installed packages
- Use least privilege principle for AWS IAM roles
- Keep Terraform state secure, preferably using remote state with encryption
- Regularly rotate SSH keys and update security group rules

## Contributing
Contributions are welcome. Please fork the repository and submit a pull request with your proposed changes.
