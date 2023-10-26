resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  wait             = false
  values           = ["${file("./manifests/values.yml")}"]
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
