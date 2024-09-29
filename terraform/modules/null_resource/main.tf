resource "null_resource" "ansible_playbook" {
  triggers = {
    instance_id = var.instance_id
  }

  depends_on = [var.instance_id]

  provisioner "local-exec" {
    command = <<EOT
      while ! nc -z ${var.public_ip} 22; do   
        echo "Waiting for SSH to be available..."
        sleep 90
      done

      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${var.public_ip},' ${var.playbook} \
      -e "ansible_host=${var.public_ip}" \
      -e "ansible_user=ansible" \
      -e "ansible_ssh_private_key_file=${var.private_key_path}"
    EOT

    environment = {
      ANSIBLE_PRIVATE_KEY_FILE = var.private_key_path
      EC2_PUBLIC_IP            = var.public_ip
    }
  }
}