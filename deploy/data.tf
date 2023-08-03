data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/manifests/*.yml"
  vars = {
    db_user         = var.db_user
    db_password     = var.db_password
    db_port         = var.db_port
    db_name         = var.db_name
    ssl_certificate = data.terraform_remote_state.ssl.outputs.cert
    #    rds_address     = data.terraform_remote_state.rds.outputs.rds_address
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
