resource "kubernetes_deployment" "shipping" {
  metadata {
    name      = "shipping"
    namespace = var.namespace
    labels = {
      name = "shipping"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "shipping"
      }
    }

    template {
      metadata {
        labels = {
          name = "shipping"
        }
      }

      spec {
        container {
          name  = "shipping"
          image = "weaveworksdemos/shipping:0.4.8"
          env {
            name = "MYSQL_PORT"
            value = "3306"
          }
          env {
            name  = "ZIPKIN"
            value = "zipkin.jaeger.svc.cluster.local"
          }

          env {
            name  = "JAVA_OPTS"
            value = "-Xms64m -Xmx128m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false"
          }

          resources {
            limits = {
              cpu    = "300m"
              memory = "500Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "300Mi"
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

          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
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
