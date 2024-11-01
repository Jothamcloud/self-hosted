resource "null_resource" "ansible_playbook" {
  triggers = {
    instance_id = var.instance_id
  }

 
  depends_on = [var.instance_id]

  provisioner "local-exec" {
    command = <<EOT
      # Wait for 90 seconds to allow the server to initialize and SSH service to be ready
      echo "Waiting for 70 seconds for SSH to be available..."
      sleep 70

      # Running the Ansible playbook
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${var.public_ip},' ${var.playbook} \
      -e "ansible_host=${var.public_ip}" \
      -e "ansible_user=ansible" \
      -e "ansible_ssh_private_key_file=${var.private_key_path}" \
      -e "j_domain=${var.jenkins_fqdn}" \
      -e "g_domain=${var.grafana_fqdn}" \
      -e "p_domain=${var.prometheus_fqdn}" \
      -e "v_domain=${var.vault_fqdn}" \
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
      ANSIBLE_PRIVATE_KEY_FILE = var.private_key_path
      EC2_PUBLIC_IP            = var.public_ip
    }
  }
}
