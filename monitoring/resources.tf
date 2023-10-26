resource "helm_release" "prometheus" {
  name             = "prometheus"
  create_namespace = true
  namespace        = "monitoring"
  version          = "~> 45.0.0"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  wait             = false
  values           = ["${file("../ansible/alert.yml")}"]
}
