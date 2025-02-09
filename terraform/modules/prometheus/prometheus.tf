resource "aws_iam_policy" "prometheus_ec2_discovery" {
  name        = "PrometheusEC2DiscoveryPolicy"
  description = "Policy for Prometheus to discover EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "prometheus_role" {
  name = "PrometheusRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.cluster_oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${var.cluster_oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:prometheus"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prometheus_attach_policy" {
  role       = aws_iam_role.prometheus_role.name
  policy_arn = aws_iam_policy.prometheus_ec2_discovery.arn
}

resource "kubernetes_service_account" "prometheus" {
  metadata {
    name      = "svc-acc-prometheus"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.prometheus_role.arn
    }
  }
}

resource "kubernetes_namespace" "kube-namespace" {

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  depends_on = [
    kubernetes_namespace.kube-namespace 
  ]
  
  name             = var.helm_release_name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true
  version          = var.prometheus_version
  
  values = [
    file("${path.module}/values.yaml")
  ]
  
  timeout = 2000

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  set {
    name  = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}
