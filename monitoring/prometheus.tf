resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "27.28.0"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  depends_on = [kubernetes_namespace.prometheus]
}
