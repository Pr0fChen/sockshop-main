resource "kubernetes_service" "orders_db" {
  metadata {
    name      = "orders-db"
    namespace = var.namespace
    labels = {
      name = "orders-db"
    }
  }

  spec {
    port {
      port        = 27017
      target_port = 27017
    }

    selector = {
      name = "orders-db"
    }
  }
}
