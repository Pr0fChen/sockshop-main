resource "kubernetes_service" "front_end" {
  metadata {
    name      = "front-end"
    namespace = var.namespace
    labels = {
      name = "front-end"
    }
    annotations = {
      "prometheus.io/scrape" = "true"
    }
  }

  spec {

    port {
      port        = 80
      target_port = 8079
    }

    selector = {
      name = "front-end"
    }
  }
}
