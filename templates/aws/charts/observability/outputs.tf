output "grafana_loki_url" {
  value = var.loki_stack_enabled ? module.loki_stack.grafana_url : null
}

output "kubeshark_url" {
  value = var.kubeshark_enabled ? module.kubeshark[0].kubeshark_url : null
}

output "jaeger_url" {
  value = var.jaeger_enabled ? module.jaeger[0].jaeger_url : null
}

output "jaeger_demo_url" {
  value = var.jaeger_demo_app_enabled ? module.jaeger[0].jaeger_demo_url : null
}

output "grafana_url" {
  value = var.kube_prometheus_stack_enabled ? module.kube_prometheus_stack[0].grafana_url : null
}

output "prometheus_url" {
  value = var.kube_prometheus_stack_enabled ? module.kube_prometheus_stack[0].prometheus_url : null
}

output "alertmanager_url" {
  value = var.kube_prometheus_stack_enabled ? module.kube_prometheus_stack[0].alertmanager_url : null
}
