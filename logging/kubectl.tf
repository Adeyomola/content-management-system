data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/manifests/*.yml"
}

#resource "kubernetes_namespace" "namespaces" {
#  metadata {
#    name = "logging"
#  }
#}

resource "kubectl_manifest" "deploy" {
#  depends_on = [kubernetes_namespace.namespaces]
  for_each   = toset(data.kubectl_path_documents.manifests.documents)
  yaml_body  = each.value
}
