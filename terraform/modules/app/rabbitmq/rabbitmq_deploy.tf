resource "kubernetes_deployment" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = var.namespace
    labels = {
      name = "rabbitmq"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "rabbitmq"
      }
    }

    template {
      metadata {
        labels = {
          name = "rabbitmq"
        }
        annotations = {
          "prometheus.io/scrape" = "false"
        }
      }

      spec {
        # Ajout de l'initContainer pour corriger les permissions
        init_container {
          name  = "fix-rabbitmq-permissions"
          image = "busybox"
          command = ["sh", "-c", "chown -R 999:999 /var/lib/rabbitmq"]

          volume_mount {
            mount_path = "/var/lib/rabbitmq"
            name       = "rabbitmq-storage"
          }
        }

        container {
          name  = "rabbitmq"
          image = "rabbitmq:3.6.8-management"

          env {
            name  = "MYSQL_PORT"
            value = "3306"
          }

          port {
            container_port = 15672
            name           = "management"
          }

          port {
            container_port = 5672
            name           = "rabbitmq"
          }

          security_context {
            capabilities {
              drop = ["all"]
              add  = ["CHOWN", "SETGID", "SETUID", "DAC_OVERRIDE"]
            }

            read_only_root_filesystem = true
          }

          volume_mount {
            mount_path = "/var/lib/rabbitmq"
            name       = "rabbitmq-storage"
          }
        }

        container {
          name  = "rabbitmq-exporter"
          image = "kbudde/rabbitmq-exporter"

          port {
            container_port = 9090
            name           = "exporter"
          }
        }

        volume {
          name = "rabbitmq-storage"

          persistent_volume_claim {
            claim_name = "rabbitmq-pvc"
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
