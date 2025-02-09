resource "kubernetes_deployment" "carts_db" {
  metadata {
    name      = "carts-db"
    namespace = var.namespace
    labels = {
      name = "carts-db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "carts-db"
      }
    }

    template {
      metadata {
        labels = {
          name = "carts-db"
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
            name       = "carts-db-storage"
          }
        }

        container {
          name  = "carts-db"
          image = "mongo:3.6"

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
            name       = "carts-db-storage"
          }

        }

        volume {
          name = "carts-db-storage"

          persistent_volume_claim {
            claim_name = "cart-db-pvc"
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
