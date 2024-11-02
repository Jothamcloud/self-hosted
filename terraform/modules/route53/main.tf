resource "aws_route53_record" "jenkins" {
  zone_id = var.zone_id
  name    = "jenkins.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.public_ip]
}

output "jenkins_fqdn" {
  value = aws_route53_record.jenkins.fqdn
}

resource "aws_route53_record" "grafana" {
  zone_id = var.zone_id
  name    = "grafana.${var.domain_name}"
  type    = "A"
  ttl     = 300
 records = [var.public_ip]
}

output "grafana_fqdn" {
  value = aws_route53_record.grafana.fqdn
}

resource "aws_route53_record" "prometheus" {
  zone_id = var.zone_id
  name    = "prometheus.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.public_ip]
}

output "prometheus_fqdn" {
  value = aws_route53_record.prometheus.fqdn
}

resource "aws_route53_record" "vault" {
  zone_id = var.zone_id
  name    = "vault.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.public_ip]
}

output "vault_fqdn" {
  value = aws_route53_record.vault.fqdn
}

resource "aws_route53_record" "gitea" {
  zone_id = var.zone_id
  name    = "gitea.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.public_ip]
}

output "gitea_fqdn" {
  value = aws_route53_record.gitea.fqdn
}