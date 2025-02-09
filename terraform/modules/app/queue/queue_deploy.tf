resource "kubernetes_deployment" "queue_master" {
  metadata {
    name      = "queue-master"
    namespace = var.namespace
    labels = {
      name = "queue-master"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "queue-master"
      }
    }

    template {
      metadata {
        labels = {
          name = "queue-master"
        }
      }

      spec {
        container {
          name  = "queue-master"
          image = "weaveworksdemos/queue-master:0.3.1"
          env {
            name = "MYSQL_PORT"
            value = "3306"
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
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
