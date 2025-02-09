# data "http" "lbc_iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
#   request_headers = {
#     Accept = "application/json"
#   }
# }

# output "lbc_iam_policy" {
#   value = data.http.lbc_iam_policy.response_body
# }

# resource "aws_iam_policy" "lbc_iam_policy" {
#   name        = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"
#   path        = "/"
#   description = "AWS Load Balancer Controller IAM Policy"

#   policy = data.http.lbc_iam_policy.response_body
# }

# output "lbc_iam_policy_arn" {
#   value = aws_iam_policy.lbc_iam_policy.arn
# }

# resource "aws_iam_role" "lbc_iam_role" {
#   name = "${var.cluster_name}-lbc-iam-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Federated = "${var.oidc_provider_arn}"
#         }
#         Condition = {
#           StringEquals = {
#             "${var.oidc_provider}:aud" : "sts.amazonaws.com",
#             "${var.oidc_provider}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
#           }
#         }
#       },
#     ]
#   })

#   tags = {
#     environment = "PROD"
#   }
# }

# resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.lbc_iam_policy.arn
#   role       = aws_iam_role.lbc_iam_role.name
# }

# # Helm release pour installer AWS Load Balancer Controller
# resource "helm_release" "loadbalancer_controller" {
#   depends_on = [aws_iam_role.lbc_iam_role]

#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
  
#   set {
#     name  = "image.repository"
#     value = "602401143452.dkr.ecr.eu-west-3.amazonaws.com/amazon/aws-load-balancer-controller"
#     # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.lbc_iam_role.arn
#   }

#   set {
#     name  = "clusterName"
#     value = var.cluster_name
#   }

#   set {
#     name  = "region"
#     value = var.region
#   }

#   set {
#     name  = "vpcId"
#     value = var.vpc_id
#   }
# }

# resource "kubernetes_ingress_class_v1" "ingress_class_default" {
#   depends_on = [helm_release.loadbalancer_controller]

#   metadata {
#     name = "my-aws-ingress-class"
#     annotations = {
#       "ingressclass.kubernetes.io/is-default-class" = "true"
#     }
#   }
#   spec {
#     controller = "ingress.k8s.aws/alb"
#   }
# }








data "aws_iam_policy_document" "aws_lbc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "aws_lbc" {
  name               = "${var.cluster_name}-aws-lbc"
  assume_role_policy = data.aws_iam_policy_document.aws_lbc.json
}

resource "aws_iam_policy" "aws_lbc" {
  policy = file("${path.module}/iam/AWSLoadBalancerController.json")
  name   = "AWSLoadBalancerController"
}

resource "aws_iam_role_policy_attachment" "aws_lbc" {
  policy_arn = aws_iam_policy.aws_lbc.arn
  role       = aws_iam_role.aws_lbc.name
}

resource "aws_eks_pod_identity_association" "aws_lbc" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.aws_lbc.arn
}

resource "helm_release" "aws_lbc" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.2"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}