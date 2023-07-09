#output "dns" {
#  description = "The DNS name of the load balancer."
#  value       = data.kubernetes_ingress.lb.status.0.load_balancer.0.ingress.0.hostname
#}
