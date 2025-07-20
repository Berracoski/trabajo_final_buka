resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.2.10"
  namespace  = kubernetes_namespace.grafana.metadata[0].name

  values = [
    file("${path.module}/grafana-values.yaml")
  ]

  depends_on = [kubernetes_namespace.grafana]
}
