resource "kubernetes_service" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = var.namespace
    labels = {
      name = "rabbitmq"
    }
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "9090"
    }
  }

  spec {
    port {
      port        = 5672
      target_port = 5672
      name        = "rabbitmq"
    }

    port {
      port        = 9090
      target_port = "exporter"
      name        = "exporter"
      protocol    = "TCP"
    }

    selector = {
      name = "rabbitmq"
    }
  }
}
