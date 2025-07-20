resource "kubernetes_namespace" "prometheus" {
  provider = kubernetes.eks
  metadata {
    name = "prometheus"
  }
}

resource "kubernetes_namespace" "grafana" {
  provider = kubernetes.eks
  metadata {
    name = "grafana"
  }
}
