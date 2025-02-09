resource "kubernetes_service" "catalogue_db" {
  metadata {
    name      = "catalogue-db"
    namespace = var.namespace
    labels = {
      name = "catalogue-db"
    }
  }

  spec {
    port {
      port        = 3306
      target_port = 3306
    }

    selector = {
      name = "catalogue-db"
    }
  }
}
