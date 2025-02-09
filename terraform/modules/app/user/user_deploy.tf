resource "kubernetes_deployment" "user" {
  metadata {
    name      = "user"
    namespace = var.namespace
    labels = {
      name = "user"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "user"
      }
    }

    template {
      metadata {
        labels = {
          name = "user"
        }
      }

      spec {
        container {
          name  = "user"
          image = "weaveworksdemos/user:0.4.7"
          env {
            name = "MYSQL_PORT"
            value = "3306"
          }
          resources {
            limits = {
              cpu    = "300m"
              memory = "200Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          port {
            container_port = 80
          }

          env {
            name  = "mongo"
            value = "user-db:27017"
          }

          security_context {
            run_as_non_root = true
            run_as_user     = 10001

            capabilities {
              drop = ["all"]
              add  = ["NET_BIND_SERVICE"]
            }

            read_only_root_filesystem = true
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 80
            }
            initial_delay_seconds = 300
            period_seconds         = 3
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 80
            }
            initial_delay_seconds = 180
            period_seconds         = 3
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
