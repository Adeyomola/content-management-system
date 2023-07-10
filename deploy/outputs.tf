output "dns" {
  depends_on  = [data.kubernetes_ingress_v1.lb]
  description = "The DNS name of the load balancer."
  value       = data.kubernetes_ingress_v1.lb.status.0.load_balancer.0.ingress.0.hostname
}
