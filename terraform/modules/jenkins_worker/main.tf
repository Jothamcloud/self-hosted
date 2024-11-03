resource "aws_instance" "jenkins_worker" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  user_data              = var.user_data

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }


  tags = {
    Name = "${var.instance_name}-jenkins-worker"
  }
}


output "worker_instance_id" {
  description = "ID of the Jenkins worker EC2 instance"
  value       =  aws_instance.jenkins_worker.id
}

output "worker_public_ip" {
  description = "Public IP of the Jenkins worker EC2 instance"
  value       = aws_instance.jenkins_worker.public_ip
}
