resource "kubernetes_namespace" "namespaces" {
  depends_on = [resource.helm_release.alb_controller]
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

resource "aws_iam_role" "alb_controller_role" {
  name = "alb_controller_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:aud" : "sts.amazonaws.com",
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}::sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
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
  depends_on = [aws_iam_role.alb_controller_role]
  name       = "alb-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  wait       = false
  set {
    name  = "image.repository"
    value = "public.ecr.aws/eks/aws-load-balancer-controller:v2.4.7"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = "capstone-9"
  }
  #  values           = ["${file("../ansible/alb_controller.yml")}"]
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
