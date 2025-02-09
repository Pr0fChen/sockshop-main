resource "kubernetes_service" "queue_master" {
  metadata {
    name      = "queue-master"
    namespace = var.namespace
    labels = {
      name = "queue-master"
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
      name = "queue-master"
    }
  }
}
