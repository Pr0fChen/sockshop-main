resource "kubernetes_deployment" "orders_db" {
  metadata {
    name      = "orders-db"
    namespace = var.namespace
    labels = {
      name = "orders-db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "orders-db"
      }
    }

    template {
      metadata {
        labels = {
          name = "orders-db"
        }
      }

      spec {
        # Ajout de l'initContainer pour corriger les permissions
        init_container {
          name  = "fix-mongo-permissions"
          image = "busybox"
          command = ["sh", "-c", "chown -R 999:999 /data/db"]

          volume_mount {
            mount_path = "/data/db"
            name       = "orders-db-storage"
          }
        }

        container {
          name  = "orders-db"
          image = "mongo:3.6"

          env {
            name  = "MYSQL_PORT"
            value = "3306"
          }

          port {
            name           = "mongo"
            container_port = 27017
          }

          security_context {
            capabilities {
              drop = ["all"]
              add  = ["CHOWN", "SETGID", "SETUID"]
            }

            read_only_root_filesystem = true
          }

          volume_mount {
            mount_path = "/data/db"
            name       = "orders-db-storage"
          }

          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
        }

        volume {
          name = "orders-db-storage"

          persistent_volume_claim {
            claim_name = "orders-db-pvc"
          }
        }

        volume {
          name = "tmp-volume"

          empty_dir {
            medium = "Memory"
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
