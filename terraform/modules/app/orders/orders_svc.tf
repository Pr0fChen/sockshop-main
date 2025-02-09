resource "kubernetes_service" "orders" {
  metadata {
    name      = "orders"
    namespace = var.namespace
    labels = {
      name = "orders"
    }
    annotations = {
      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    port {
      port        = 80
      target_port = 80
    }

    selector = {
      name = "orders"
    }
  }
}
