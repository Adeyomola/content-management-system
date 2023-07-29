output "cert" {
  value = aws_acm_certificate.cert.arn
}

output "certificate" {
value = acme_certificate.cert.certificate_pem
sensitive = true
}

output "key" {
value = acme_certificate.cert.private_key_pem
sensitive = true
}
