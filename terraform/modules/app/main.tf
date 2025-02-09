# Appel des modules de déploiement des applications
resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "sock-shop"
  }
}

# module "carts" {
#   source = "./carts"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "catalogue" {
#   source = "./catalogue"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "frontend" {
#   source = "./frontend"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "orders" {
#   source = "./orders"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "payments" {
#   source = "./payments"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "queue" {
#   source = "./queue"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "rabbitmq" {
#   source = "./rabbitmq"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "session-db" {
#   source = "./session-db"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "shipping" {
#   source = "./shipping"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

# module "user" {
#   source = "./user"
#   namespace = kubernetes_namespace.kube-namespace.id
# }

resource "helm_release" "microservices" {
  name       = "microservices"
  chart      = "https://github.com/Pr0fChen/Sock-Shop---Helm/releases/download/0.1.0/sockshop-helm-0.1.0.tgz"  # Référence au chemin du chart décompressé
  version    = "1.0.0"
  namespace  = kubernetes_namespace.kube-namespace.id

  values = [
    file("${path.module}/values.yaml")
  ]
}