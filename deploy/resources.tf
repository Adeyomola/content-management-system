resource "kubernetes_namespace" "namespaces" {
  for_each   = var.namespaces
  metadata {
    name = each.value
  }
}

resource "kubectl_manifest" "deploy" {
  depends_on = [kubernetes_namespace.namespaces]
  for_each   = toset(data.kubectl_path_documents.manifests.documents)
  yaml_body  = each.value
}

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

resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  wait             = false
}

resource "helm_release" "logstash" {
  name             = "logstash"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "logstash"
  wait             = false
}

#resource "helm_release" "kibana" {
#  name             = "kibana"
#  create_namespace = true
#  namespace        = "logging"
#  repository       = "https://helm.elastic.co"
#  chart            = "kibana"
#  wait             = false
#}

resource "helm_release" "mysql_exporter" {
  depends_on = [kubectl_manifest.deploy]
  name       = "mysqlexporter-${var.namespaces_list[0]}"
  chart      = "prometheus-mysql-exporter"
  namespace  = var.namespaces_list[0]
  repository = "https://prometheus-community.github.io/helm-charts"
  wait       = false
  values     = ["${file("../ansible/db.yml")}"]
}
