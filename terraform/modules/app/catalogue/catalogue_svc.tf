resource "kubernetes_service" "catalogue" {
  metadata {
    name      = "catalogue"
    namespace = var.namespace
    labels = {
      name = "catalogue"
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
      name = "catalogue"
    }
  }
}
