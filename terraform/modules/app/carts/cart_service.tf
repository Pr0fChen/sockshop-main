resource "kubernetes_service" "carts" {
  metadata {
    name      = "carts"
    namespace = var.namespace
    labels = {
      name = "carts"
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
      name = "carts"
    }
  }
}
