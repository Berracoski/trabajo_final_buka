resource "kubernetes_service" "nginx" {
  provider = kubernetes.eks
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata[0].labels.app #Esto esta referenciando al objeto deployment nginx, trayendose la metadata el valor de la label app de nginx.tf
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}
