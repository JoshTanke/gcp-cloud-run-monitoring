
output "service_url" {
  description = "URL of the Cloud Run service"
  value       = module.cloud_run_service.service_url
}

output "dashboard_url" {
  description = "URL to the monitoring dashboard"
  value       = module.monitoring.dashboard_url
}

output "service_account_email" {
  description = "Email of the service account"
  value       = module.cloud_run_service.service_account_email
}

output "alert_policy_ids" {
  description = "IDs of the created alert policies"
  value       = module.monitoring.alert_policy_ids
}
