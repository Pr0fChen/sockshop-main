resource "kubernetes_deployment" "catalogue" {
  metadata {
    name      = "catalogue"
    namespace = var.namespace
    labels = {
      name = "catalogue"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "catalogue"
      }
    }

    template {
      metadata {
        labels = {
          name = "catalogue"
        }
      }

      spec {
        container {
          name  = "catalogue"
          image = "weaveworksdemos/catalogue:0.3.5"
          env {
            name = "MYSQL_PORT"
            value = "3306"
          }
          command = ["/app"]
          args    = ["-port=80"]

          resources {
            limits = {
              cpu    = "200m"
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
