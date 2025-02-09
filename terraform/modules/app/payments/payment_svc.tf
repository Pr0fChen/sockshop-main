resource "kubernetes_service" "payment" {
  metadata {
    name      = "payment"
    namespace = var.namespace
    labels = {
      name = "payment"
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
      name = "payment"
    }
  }
}
