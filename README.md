
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

1. **Update Configuration**
   ```bash
   # Edit infra/environments/dev/main.tf
   # Set your GCP project ID and alert email
   ```

2. **Deploy Infrastructure**
   ```bash
   cd infra/environments/dev
   terraform init
   terraform plan
   terraform apply
   ```

3. **Access Dashboard**
   - Dashboard URL will be output after deployment
   - Or find it in GCP Console → Monitoring → Dashboards

## Configuration

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

## Troubleshooting

### Common Issues
1. **Permission Errors**: Ensure your service account has Monitoring Admin and Logging Admin roles
2. **No Data in Dashboard**: Verify your Cloud Run service is receiving traffic
3. **Alerts Not Firing**: Check that log filters match your application's log format

### Useful Commands
```bash
# Check service logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=my-app"

# Test alert policies
gcloud alpha monitoring policies list

# View dashboard
gcloud monitoring dashboards list
```

## Cost Optimization

- Uses CPU idle mode to reduce costs when not serving requests
- Configurable min/max instances for cost control
- Log-based metrics only charge for log ingestion, not metric storage

## Next Steps

- Set up additional notification channels (Slack, PagerDuty)
- Add custom business metrics
- Implement SLO monitoring
- Set up log-based SLI tracking
