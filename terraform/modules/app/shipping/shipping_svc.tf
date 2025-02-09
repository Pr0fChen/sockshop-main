resource "kubernetes_service" "shipping" {
  metadata {
    name      = "shipping"
    namespace = var.namespace
    labels = {
      name = "shipping"
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
      name = "shipping"
    }
  }
}
