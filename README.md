
# GCP Cloud Run Monitoring with Terraform

Complete monitoring setup for Google Cloud Run services with alerts and dashboards.

## File Structure

```
infra/
├── environments/dev/     # Environment-specific config
│   ├── main.tf          # Main configuration
│   ├── variables.tf     # Input variables
│   └── outputs.tf       # Output values
└── modules/
    ├── cloud_run_service/     # Cloud Run service module
    └── cloud_run_monitoring/  # Monitoring setup module
```

Copy the `dev` environment to create `staging` or `prod` with different configurations.

## What You Get

- **Error Rate Alerts**: Triggers when errors exceed 5/minute (configurable)
- **Latency Alerts**: Triggers when 95th percentile latency exceeds 2000ms (configurable)  
- **Critical Error Alerts**: Log-based alerts for CRITICAL/EMERGENCY/FATAL entries
- **Monitoring Dashboard**: Request count, latency, error rate, and instance metrics
- **Email Notifications**: With rate limiting to prevent spam

## Quick Start

1. **Prerequisites**
   - Terraform installed
   - `gcloud` CLI authenticated
   - GCP project with Cloud Run, Monitoring, and Logging APIs enabled

2. **Configure**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Deploy**
   ```bash
   cd infra/environments/dev
   terraform init
   terraform plan
   terraform apply
   ```

4. **Access Dashboard**
   - Dashboard URL will be in the terraform output
   - Or find it in GCP Console → Monitoring → Dashboards

## Configuration

Edit `terraform.tfvars`:

```hcl
gcp_project_id = "your-project-id"
service_name   = "my-app"
alert_email    = "alerts@example.com"
image_url      = "gcr.io/your-project/your-app"

# Optional customizations
error_rate_threshold = 5     # errors per minute
latency_threshold_ms = 2000  # milliseconds
min_instances        = 0
max_instances        = 10
```

## State Backend Options

Choose one in `infra/environments/dev/main.tf`:

```hcl
# Local state (default)
# No backend block needed

# GCS backend
backend "gcs" {
  bucket = "your-terraform-state-bucket"
  prefix = "cloud-run-monitoring/dev"
}

# S3 backend  
backend "s3" {
  bucket = "your-terraform-state-bucket"
  key    = "cloud-run-monitoring/dev/terraform.tfstate"
  region = "us-east-1"
}
```

## What's Monitored

- **HTTP Errors**: 4xx/5xx status codes
- **Log Errors**: ERROR severity logs
- **Request Latency**: 95th percentile response times
- **Critical Logs**: CRITICAL/EMERGENCY/FATAL severity
- **Instance Count**: Auto-scaling metrics

## Troubleshooting

**Permission errors?** Ensure your account has:
- Monitoring Admin
- Logging Admin  
- Cloud Run Admin

**No dashboard data?** 
- Check your service is receiving traffic
- Verify service name matches in both modules

**Alerts not firing?**
- Test with some traffic to trigger thresholds
- Check alert thresholds match your expected traffic patterns
