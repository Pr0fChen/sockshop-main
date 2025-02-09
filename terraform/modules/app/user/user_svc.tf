resource "kubernetes_service" "user" {
  metadata {
    name      = "user"
    namespace = var.namespace
    labels = {
      name = "user"
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
      name = "user"
    }
  }
}
