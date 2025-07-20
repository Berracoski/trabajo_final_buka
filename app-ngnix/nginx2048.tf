resource "kubernetes_namespace" "game" {
  provider = kubernetes.eks
  metadata {
    name = "game"
  }
}

resource "kubernetes_deployment" "game_2048" {
  provider = kubernetes.eks
  metadata {
    name      = "game-2048"
    namespace = kubernetes_namespace.game.metadata[0].name
    labels = {
      app = "game-2048"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "game-2048"
      }
    }

    template {
      metadata {
        labels = {
          app = "game-2048"
        }
      }

      spec {
        container {
          name  = "game-2048"
          image = "public.ecr.aws/kishorj/docker-2048:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "game_2048" {
  provider = kubernetes.eks
  metadata {
    name      = "game-2048-service"
    namespace = kubernetes_namespace.game.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.game_2048.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
