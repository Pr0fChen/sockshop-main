resource "kubernetes_deployment" "catalogue_db" {
  metadata {
    name      = "catalogue-db"
    namespace = var.namespace
    labels = {
      name = "catalogue-db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "catalogue-db"
      }
    }

    template {
      metadata {
        labels = {
          name = "catalogue-db"
        }
      }

      spec {
        # Ajout de l'initContainer pour corriger les permissions
        init_container {
          name  = "fix-mysql-permissions"
          image = "busybox"
          command = ["sh", "-c", "chown -R 999:999 /var/lib/mysql"]

          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "catalogue-db-storage"
          }
        }

        container {
          name  = "catalogue-db"
          image = "weaveworksdemos/catalogue-db:0.3.0"

          env {
            name  = "MYSQL_PORT"
            value = "3306"
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "test"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "socksdb"
          }

          port {
            name           = "mysql"
            container_port = 3306
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "catalogue-db-storage"
          }
        }

        volume {
          name = "catalogue-db-storage"

          persistent_volume_claim {
            claim_name = "catalogue-db-pvc"
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
