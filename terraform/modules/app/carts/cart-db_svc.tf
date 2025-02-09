resource "kubernetes_service" "carts_db" {
  metadata {
    name      = "carts-db"
    namespace = var.namespace
    labels = {
      name = "carts-db"
    }
  }

  spec {
    port {
      port        = 27017
      target_port = 27017
    }

    selector = {
      name = "carts-db"
    }
  }
}
