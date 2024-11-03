resource "local_file" "ansible_inventory" {
  content = <<EOF
[server]
${var.public_ip}

[worker]
${var.worker_public_ip}
EOF  
filename = "./ansible/inventory.ini"
}


resource "null_resource" "ansible_playbook" {
  triggers = {
    instance_id = var.instance_id
  }

 
  depends_on = [var.instance_id]

  provisioner "local-exec" {
    working_dir = "./ansible"
    command = <<EOT
      # Wait for 90 seconds to allow the server to initialize and SSH service to be ready
      echo "Waiting for 70 seconds for SSH to be available..."
      sleep 70

      # Running the Ansible playbook
     ansible-playbook playbook.yml \
      -e "j_domain=${var.jenkins_fqdn}" \
      -e "g_domain=${var.grafana_fqdn}" \
      -e "p_domain=${var.prometheus_fqdn}" \
      -e "v_domain=${var.vault_fqdn}" \
      -e "t_domain=${var.gitea_fqdn}" \
      -e "s3_access_key=${var.s3_access_key}" \
      -e "s3_secret_key=${var.s3_secret_key}" \
      -e "s3_bucket_name=${var.s3_bucket_name}" \
      -e "restore=${var.restore}" \
      -e "init=${var.init}" \
      -e "aws_region=${var.aws_region}" \
      -e "aws_kms_key_id=${var.aws_kms_key_id}" \
      -e "ansible_ssh_port=${var.ssh_port}"
    EOT

    environment = {
      # ANSIBLE_PRIVATE_KEY_FILE = var.private_key_path
      EC2_PUBLIC_IP            = var.public_ip
    }
  }
}
