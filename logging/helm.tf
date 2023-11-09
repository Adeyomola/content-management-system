resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  wait             = false
  values           = ["${file("values.yml")}"]
#  version          = "8.5.1"
}

resource "helm_release" "logstash" {
  name             = "logstash"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "logstash"
  wait             = false
}

resource "helm_release" "kibana" {
  name             = "kibana"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  wait             = false
}

resource "helm_release" "filebeat" {
  name             = "filebeat"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "filebeat"
  wait             = false
}
