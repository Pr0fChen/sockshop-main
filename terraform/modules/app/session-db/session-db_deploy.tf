resource "kubernetes_deployment" "session_db" {
  metadata {
    name      = "session-db"
    namespace = var.namespace
    labels = {
      name = "session-db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "session-db"
      }
    }

    template {
      metadata {
        labels = {
          name = "session-db"
        }
        annotations = {
          "prometheus.io.scrape" = "false"
        }
      }

      spec {
        # Ajout de l'initContainer pour corriger les permissions
        init_container {
          name  = "fix-redis-permissions"
          image = "busybox"
          command = ["sh", "-c", "chown -R 999:999 /data"]

          volume_mount {
            mount_path = "/data"
            name       = "session-db-storage"
          }
        }

        container {
          name  = "session-db"
          image = "redis:alpine"

          env {
            name  = "MYSQL_PORT"
            value = "3306"
          }

          port {
            name           = "redis"
            container_port = 6379
          }

          security_context {
            capabilities {
              drop = ["all"]
              add  = ["CHOWN", "SETGID", "SETUID"]
            }

            read_only_root_filesystem = true
          }

          volume_mount {
            mount_path = "/data"
            name       = "session-db-storage"
          }
        }

        volume {
          name = "session-db-storage"

          persistent_volume_claim {
            claim_name = "session-db-pvc"
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
