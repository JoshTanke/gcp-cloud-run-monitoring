
# GCP Cloud Run Monitoring with Terraform

This project sets up comprehensive monitoring for Google Cloud Run services including log-based alerts and latency monitoring dashboards.

## Features

### 🚨 Alert Policies
- **High Error Rate**: Triggers when error rate exceeds threshold (default: 5 errors/minute)
- **High Latency**: Triggers when 95th percentile latency exceeds threshold (default: 2000ms)
- **Critical Errors**: Log-based alert for CRITICAL/EMERGENCY/FATAL log entries

### 📊 Monitoring Dashboard
- Request count over time
- Request latency (95th percentile)
- Error rate tracking
- Instance count monitoring

### 📧 Notifications
- Email notifications for all alerts
- Rate limiting to prevent spam (max 1 notification per 5 minutes for log-based alerts)

## Quick Start

### 1. Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and authenticated
- GCP project with the following APIs enabled:
  - Cloud Run API
  - Cloud Monitoring API
  - Cloud Logging API

### 2. Configuration

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd gcp-cloud-run-monitoring
   ```

2. **Configure your environment**
   
   Edit `infra/environments/dev/main.tf` and update the `locals` block:
   ```hcl
   locals {
     gcp_project_id = "your-actual-project-id"
     region         = "us-central1"  # or your preferred region
     service_name   = "your-app-name"
     alert_email    = "your-email@example.com"
   }
   ```

3. **Configure state backend (optional)**
   
   Choose one of the following options in `infra/environments/dev/main.tf`:

   **Option A: Local state (default)**
   ```hcl
   # No backend configuration needed - uses local state
   ```

   **Option B: Google Cloud Storage**
   ```hcl
   backend "gcs" {
     bucket = "your-terraform-state-bucket"
     prefix = "cloud-run-monitoring/dev"
   }
   ```

   **Option C: AWS S3**
   ```hcl
   backend "s3" {
     bucket = "your-terraform-state-bucket"
     key    = "cloud-run-monitoring/dev/terraform.tfstate"
     region = "us-east-1"
   }
   ```

### 3. Deploy Infrastructure

```bash
cd infra/environments/dev
terraform init
terraform plan
terraform apply
```

### 4. Access Dashboard
- Dashboard URL will be output after deployment
- Or find it in GCP Console → Monitoring → Dashboards

## Configuration Options

### Service Configuration
```hcl
module "cloud_run_service" {
  source = "../../modules/cloud_run_service"
  
  service_name = "my-app"
  region       = "us-central1"
  image_url    = "gcr.io/your-project/your-app"
  
  # Adjust resources as needed
  cpu_limit    = "1"
  memory_limit = "512Mi"
  
  # Scaling settings
  min_instances = 0
  max_instances = 10
  
  # Environment variables
  env_vars = {
    ENV = "production"
    API_KEY = "your-api-key"
  }
  
  # Access control
  allow_public_access = true  # Set to false for private services
}
```

### Monitoring Configuration
```hcl
module "monitoring" {
  source = "../../modules/cloud_run_monitoring"
  
  service_name           = "my-app"
  alert_email           = "alerts@yourcompany.com"
  error_rate_threshold  = 5    # errors per minute
  latency_threshold_ms  = 2000 # milliseconds
}
```

## Multiple Environments

To set up multiple environments (dev, staging, prod), create additional environment directories:

```
infra/
├── environments/
│   ├── dev/
│   │   └── main.tf
│   ├── staging/
│   │   └── main.tf
│   └── prod/
│       └── main.tf
└── modules/
    ├── cloud_run_service/
    └── cloud_run_monitoring/
```

Each environment can have different configurations for scaling, alerting thresholds, and resource limits.

## Log-Based Metrics

The setup creates custom log-based metrics:

1. **Error Rate Metric**: Counts HTTP 4xx/5xx responses and ERROR severity logs
2. **Request Latency Metric**: Extracts latency from HTTP request logs

## Best Practices Implemented

✅ **Structured Logging**: Monitors both HTTP status codes and log severity levels  
✅ **Rate Limiting**: Prevents alert spam with notification rate limits  
✅ **Percentile Monitoring**: Uses 95th percentile for latency alerts  
✅ **Resource Efficiency**: CPU idle mode to reduce costs  
✅ **Security**: Dedicated service account with minimal permissions  
✅ **Scalability**: Auto-scaling configuration with sensible defaults  

## Customization

### Adding More Metrics
Add custom log-based metrics in `cloud_run_monitoring/main.tf`:

```hcl
resource "google_logging_metric" "custom_metric" {
  name   = "${var.service_name}-custom-metric"
  filter = "your-custom-filter-here"
  
  metric_descriptor {
    metric_kind = "GAUGE"
    value_type  = "INT64"
  }
}
```

### Additional Alert Conditions
Extend alert policies with more conditions or create new policies for specific use cases.

### Custom Notification Channels
Add Slack, PagerDuty, or other notification channels:

```hcl
resource "google_monitoring_notification_channel" "slack" {
  display_name = "Slack Alerts"
  type         = "slack"
  labels = {
    channel_name = "#alerts"
    url          = "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"
  }
}
```

## Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure your service account has the following roles:
   - Monitoring Admin
   - Logging Admin
   - Cloud Run Admin

2. **No Data in Dashboard**: 
   - Verify your Cloud Run service is receiving traffic
   - Check that the service name matches in both modules

3. **Alerts Not Firing**: 
   - Check that log filters match your application's log format
   - Verify alert thresholds are appropriate for your traffic

4. **State Backend Issues**:
   - For GCS: Ensure the bucket exists and you have access
   - For S3: Ensure AWS credentials are configured

### Useful Commands

```bash
# Check service logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=my-app" --project=your-project-id

# Test alert policies
gcloud alpha monitoring policies list --project=your-project-id

# View dashboard
gcloud monitoring dashboards list --project=your-project-id

# Check Terraform state
terraform state list
terraform show
```

## Cost Optimization

- Uses CPU idle mode to reduce costs when not serving requests
- Configurable min/max instances for cost control
- Log-based metrics only charge for log ingestion, not metric storage
- Consider using preemptible instances for non-critical workloads

## Security Considerations

- Service account follows principle of least privilege
- Consider using Workload Identity for enhanced security
- Review IAM bindings regularly
- Use Secret Manager for sensitive environment variables

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Check the troubleshooting section above
- Review Terraform and GCP documentation
- Open an issue in this repository
