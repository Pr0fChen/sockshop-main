resource "kubernetes_horizontal_pod_autoscaler" "kube-orders-hpa" {
  metadata {
    name      = "orders-hpa"
    namespace = var.namespace
  }
  spec {
    max_replicas = 10
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.orders.metadata[0].name
    }
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type    = "Utilization"
          average_utilization = 80
        }
      }
    }
  }
}
