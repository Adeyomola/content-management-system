resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email
}

resource "acme_certificate" "cert" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  dns_challenge {
    provider = "route53"
  }
  recursive_nameservers        = ["8.8.8.8:53"]
}

resource "aws_acm_certificate" "cert" {
  private_key      = acme_certificate.cert.private_key_pem
  certificate_body = acme_certificate.cert.certificate_pem
}
