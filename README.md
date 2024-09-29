# AWS Infrastructure Automation with Terraform and Ansible

## Project Overview
This project automates the provisioning of AWS infrastructure using **Terraform** and configures the EC2 instance with **Ansible**. Terraform handles the creation of an EC2 instance, Route53 configurations, security groups, and other resources, while also automatically executing the Ansible playbook to install and configure Apache on the instance. Additionally, it sets up Jenkins and Traefik using Docker Compose.

## Directory Structure
```plaintext
terraform/
├── ansible/
│   ├── playbook.yml
│   ├── hostfile
│   ├── ansible_keys/
│   └── roles/
│       └── jenkins_traefik/
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
- [Terraform](https://www.terraform.io/downloads.html) installed on your machine
- [AWS CLI](https://aws.amazon.com/cli/) configured with your AWS credentials
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed on your machine

## Variables
In the `terraform.tfvars` file, define the following variables:
- `aws_region` - The AWS region where the resources will be created.
- `ami` - The AMI ID to use for the EC2 instance.
- `instance_type` - The type of instance to launch.
- `key_name` - The name of the key pair to use for SSH access.
- `instance_name` - The name of the EC2 instance.
- `security_name` - The name of the security group.
- `ingress_ports` - A list of port configurations for the security group.
- `route53_zone_id` - The Route53 zone ID for your domain.
- `domain_name` - The domain name to associate with your instance.

### Example Variables Structure
```hcl
aws_region      = "your-aws-region"
ami             = "your-ami-id"
instance_type   = "your-instance-type"
key_name        = "your-key-name"
instance_name   = "your-instance-name"
security_name   = "your-security-group-name"
route53_zone_id = "your-route53-zone-id"
domain_name     = "your-domain-name"

ingress_ports = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "http"
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "https"
  },
  {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    description = "ping"
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "ssh"
  }
]
```

## Usage
1. **Clone the Repository**
   ```bash
   git clone <your-repo-url>
   cd <your-repo-name>/terraform
   ```

2. **Configure AWS CLI**
   Ensure your AWS CLI is configured with the necessary credentials:
   ```bash
   aws configure
   ```

3. **Initialize Terraform**
   Initialize the Terraform workspace.
   ```bash
   terraform init
   ```

4. **Plan the Deployment**
   Create an execution plan to see what resources will be created.
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**
   Apply the Terraform configuration to create the resources and run the Ansible playbook.
   ```bash
   terraform apply
   ```

6. **Verify the Deployment**
   After the apply command completes, verify that the EC2 instance is up and running. You can SSH into the instance using:
   ```bash
   ssh -i ./ansible/ansible_keys/<your-key-file> <your-username>@<instance-public-ip>
   ```


## Jenkins and Traefik Configuration

This project includes automated setup for Jenkins and Traefik using Docker Compose and Ansible.

### Ansible Tasks (`roles/jenkins_traefik/tasks/main.yml`)

The main tasks file includes steps to:
1. Install Docker
2. Install Docker Compose
3. Create necessary directories
4. Copy the Docker Compose template
5. Start Jenkins and Traefik using Docker Compose

```yaml
---

- name: Install Docker
  apt:
    name: docker.io
    state: present
    update_cache: yes


- name: Install Docker Compose
  get_url:
    url: "https://github.com/docker/compose/releases/download/v2.21.2/docker-compose-{{ ansible_system | lower }}-{{ ansible_architecture }}"
    dest: "/usr/local/bin/docker-compose"
    mode: '0755'


- name: Create Jenkins directory
  file:
    path: /opt/jenkins-traefik
    state: directory
    mode: '0755'


- name: Copy docker-compose.yml file
  template:
    src: docker-compose.yml.j2
    dest: /opt/jenkins-traefik/docker-compose.yml



- name: Run Docker Compose to start Jenkins and Traefik
  command: docker-compose up -d
  args:
    chdir: /opt/jenkins-traefik
```

### Docker Compose Template (`roles/jenkins_traefik/templates/docker-compose.yml.j2`)

This template defines the services for Jenkins and Traefik:

```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"

  jenkins:
    image: jenkins/jenkins:lts
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.jenkins.rule=Host(`jenkins.domain.com`)"
      - "traefik.http.routers.jenkins.entrypoints=web"
      - "traefik.http.services.jenkins.loadbalancer.server.port=8080"
    environment:
      - JENKINS_OPTS=--httpPort=8080
    volumes:
      - jenkins_home:/var/jenkins_home

volumes:
  jenkins_home:
```

### Updating Your Playbook

To include this new role in your Ansible playbook, update your `playbook.yml`:

```yaml
---
- hosts: all
  become: yes
  roles:
    - jenkins_traefik
```

### Accessing Jenkins

Once deployed, Jenkins will be accessible via:
```
http://jenkins.domain.com
```
Replace `domain.com` with your actual domain.

## Cleaning Up
To remove all resources created by Terraform, run:
```bash
terraform destroy
```

## Troubleshooting
If you encounter any issues:
1. Ensure all variables in `terraform.tfvars` are correctly set.
2. Check that your AWS credentials are properly configured.
3. Verify that the specified AMI is available in your chosen region.
4. Review the Terraform and Ansible logs for any error messages.

## Security Considerations
- Regularly update the AMI and installed packages.
- Use the principle of least privilege when setting up AWS IAM roles.
- Keep your Terraform state file secure, preferably using remote state with encryption.
- Regularly rotate SSH keys and update security group rules as needed.

## Contributing
Contributions to this project are welcome. Please fork the repository and submit a pull request with your proposed changes.

