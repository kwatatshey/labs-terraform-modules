# https://github.com/kyverno/kyverno
resource "helm_release" "kyverno" {
  name             = var.kyverno_chart_name
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = var.kyverno_chart_name
  version          = var.kyverno_chart_version
  create_namespace = true
  namespace        = var.kyverno_namespace

  # High Availability (https://kyverno.io/docs/installation/methods/)
  set {
    name  = "admissionController.replicas"
    value = "3"
  }

  set {
    name  = "backgroundController.replicas"
    value = "2"
  }

  set {
    name  = "cleanupController.replicas"
    value = "2"
  }

  set {
    name  = "reportsController.replicas"
    value = "2"
  }


  #   values = yamldecode(file("${path.module}/values/kyverno-policy.yaml"))


  // Omitting namespace to install Kyverno cluster-wide
  // namespace = "kyverno"
}

# resource "helm_release" "kyverno_policies" {
#   depends_on = [helm_release.kyverno]
#   name       = "kyverno-policies"
#   repository = "https://kyverno.github.io/kyverno/"
#   chart      = "kyverno-policies"
#   namespace  = "kyverno" # Make sure to deploy in the same namespace as Kyverno

#   # Add any additional attributes or values here if needed
# }



resource "kubectl_manifest" "kyverno_cluster_policy" {
  depends_on = [helm_release.kyverno]
  yaml_body  = local.kyverno_cluster_policy_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.kyverno_cluster_policy_yaml_path)
      error_message = " --> Error: Failed to find '${local.kyverno_cluster_policy_yaml_path}'. Exit terraform process."
    }
  }
}