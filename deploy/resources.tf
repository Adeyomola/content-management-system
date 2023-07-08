resource "kubernetes_namespace" "namespaces" {
  for_each = var.namespaces
  metadata {
    name = each.value
  }
}

resource "kubectl_manifest" "deploy" {
  depends_on = [kubernetes_namespace.namespaces]
  for_each   = toset(data.kubectl_path_documents.manifests.documents)
  yaml_body  = each.value
}

resource "aws_iam_role" "alb_controller_role" {
  name = "alb_controller_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::111122223333:oidc-provider/oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud" : "sts.amazonaws.com",
            "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name   = "iam_policy"
  policy = file("./manifests/iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "helm_release" "alb_controller" {
  name             = "alb-controller"
  namespace        = "kube-system"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  wait             = false
  values           = ["${file("../ansible/alb_controller.yml")}"]
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

resource "helm_release" "kibana" {
  name             = "kibana"
  create_namespace = true
  namespace        = "logging"
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  wait             = false
}

resource "helm_release" "mysql_exporter" {
  depends_on = [kubectl_manifest.deploy]
  name       = "mysqlexporter-${var.namespaces_list[0]}"
  chart      = "prometheus-mysql-exporter"
  namespace  = var.namespaces_list[0]
  repository = "https://prometheus-community.github.io/helm-charts"
  wait       = false
  values     = ["${file("../ansible/db.yml")}"]
}
