resource "kubernetes_deployment" "user_db" {
  metadata {
    name      = "user-db"
    namespace = var.namespace
    labels = {
      name = "user-db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "user-db"
      }
    }

    template {
      metadata {
        labels = {
          name = "user-db"
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
            name       = "user-db-storage"
          }
        }

        container {
          name  = "user-db"
          image = "weaveworksdemos/user-db:0.3.0"
          
          env {
            name  = "MONGO_DB_PORT"
            value = "27017"
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
            name       = "user-db-storage"
          }
        }

        volume {
          name = "user-db-storage"

          persistent_volume_claim {
            claim_name = "user-db-pvc"
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
