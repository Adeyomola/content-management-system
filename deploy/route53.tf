data "aws_route53_zone" "selected" {
  name = var.domain_name
}

resource "aws_route53_record" "profilr" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "cms.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service_v1.lb.status.0.load_balancer.0.ingress.0.hostname]
}
