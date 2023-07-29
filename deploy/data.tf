data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/manifests/*.yml"
  vars = {
    db_user         = var.db_user
    db_password     = var.db_password
    db_port         = var.db_port
    db_name         = var.db_name
    db_port_d       = var.db_port_d
    db_name_d       = var.db_name_d
    ssl_certificate = data.terraform_remote_state.ssl.outputs.cert
  }
  sensitive_vars = {
    cert = base64encode(data.terraform_remote_state.ssl.outputs.certificate)
    key  = base64encode(data.terraform_remote_state.ssl.outputs.key)
  }
}

data "kubernetes_ingress_v1" "lb" {
  depends_on = [kubectl_manifest.deploy]
  metadata {
    name      = "app-ingress"
    namespace = "cms"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
    }
  }
}
