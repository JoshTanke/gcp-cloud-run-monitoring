
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "my-app"
}

variable "image_url" {
  description = "Container image URL"
  type        = string
  default     = "gcr.io/cloudrun/hello"
}

variable "alert_email" {
  description = "Email address to send alerts to"
  type        = string
}

variable "error_rate_threshold" {
  description = "Error rate threshold (errors per minute) to trigger alert"
  type        = number
  default     = 5
}

variable "latency_threshold_ms" {
  description = "Latency threshold in milliseconds to trigger alert"
  type        = number
  default     = 2000
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "cpu_limit" {
  description = "CPU limit for the container"
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "Memory limit for the container"
  type        = string
  default     = "512Mi"
}

variable "env_vars" {
  description = "Environment variables for the container"
  type        = map(string)
  default = {
    ENV = "development"
  }
}

variable "allow_public_access" {
  description = "Whether to allow public access to the service"
  type        = bool
  default     = true
}
