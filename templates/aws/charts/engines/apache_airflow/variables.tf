variable "name" {
  type        = string
  description = "Name of release"
  default     = "airflow"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "database_subnets" {
  type        = list(string)
  description = "List of subnet IDs"
}
variable "namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "default"
}

variable "serviceaccount" {
  type        = string
  description = "Serviceaccount name to use within the chart"
}

variable "chart_version" {
  type        = string
  description = "Helm chart to release"
  default     = "1.15.0"
}

variable "domain_name" {
  type        = string
  description = "Roure53 hosted zone name"
  default     = ""
}

variable "certificate_arn" {
  type        = string
  description = "ACM Certificate ARN"
  default     = ""
}
