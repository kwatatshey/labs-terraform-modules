variable "kyverno_chart_name" {
  type        = string
  description = "Name of chart"
}

variable "kyverno_chart_version" {
  type        = string
  description = "Version of kyverno chart"
}

variable "kyverno_namespace" {
  type        = string
  description = "Namespace to install the chart into"
}
