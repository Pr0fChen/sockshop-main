resource "kubernetes_service" "session_db" {
  metadata {
    name      = "session-db"
    namespace = var.namespace
    labels = {
      name = "session-db"
    }
  }

  spec {
    port {
      port        = 6379
      target_port = 6379
    }

    selector = {
      name = "session-db"
    }
  }
}
