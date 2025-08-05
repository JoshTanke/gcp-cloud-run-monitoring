
variable "service_name" {
  description = "Name of the Cloud Run service to monitor"
  type        = string
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
