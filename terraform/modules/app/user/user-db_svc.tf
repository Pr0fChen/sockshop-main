resource "kubernetes_service" "user_db" {
  metadata {
    name      = "user-db"
    namespace = var.namespace
    labels = {
      name = "user-db"
    }
  }

  spec {
    port {
      port        = 27017
      target_port = 27017
    }

    selector = {
      name = "user-db"
    }
  }
}
