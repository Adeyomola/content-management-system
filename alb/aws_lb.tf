resource "aws_iam_role" "alb_controller_role" {
  name = "alb_controller_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${data.terraform_remote_state.eks.outputs.oidc_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${data.terraform_remote_state.eks.outputs.oidc_provider}:aud" : "sts.amazonaws.com",
            "${data.terraform_remote_state.eks.outputs.oidc_provider}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_policy" "policy" {
  name   = "iam_policy"
  policy = file("./iam.json")
}

resource "helm_release" "alb_controller" {
  depends_on = [aws_iam_role.alb_controller_role, kubernetes_manifest.service_account]
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  wait       = false
  values     = ["${file("../ansible/alb_controller.yml")}"]
}

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
