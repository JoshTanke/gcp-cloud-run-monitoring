
output "dashboard_url" {
  description = "URL to the monitoring dashboard"
  value       = "https://console.cloud.google.com/monitoring/dashboards/custom/${split("/", google_monitoring_dashboard.cloud_run_dashboard.id)[3]}"
}

output "notification_channel_id" {
  description = "ID of the email notification channel"
  value       = google_monitoring_notification_channel.email.name
}

output "alert_policy_ids" {
  description = "IDs of the created alert policies"
  value = {
    high_error_rate = google_monitoring_alert_policy.high_error_rate.name
    high_latency    = google_monitoring_alert_policy.high_latency.name
    critical_errors = google_monitoring_alert_policy.critical_errors.name
  }
}
