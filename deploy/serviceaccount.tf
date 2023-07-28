resource "kubernetes_manifest" "service_account" {
  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      }
      name      = "aws-load-balancer-controller"
      namespace = "kube-system"
      annotations = {
        "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.account_id}:role/alb_controller_role"
      }
    }
  }
}
