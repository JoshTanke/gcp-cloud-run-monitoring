
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  # Configure your state backend here
  # For local state (default):
  # backend "local" {}
  
  # For GCS backend:
  # backend "gcs" {
  #   bucket = "your-terraform-state-bucket"
  #   prefix = "cloud-run-monitoring/dev"
  # }
  
  # For S3 backend:
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "cloud-run-monitoring/dev/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "google" {
  project = local.gcp_project_id
  region  = local.region
}

locals {
  # Update these values for your environment
  gcp_project_id = "your-gcp-project-id"  # Replace with your GCP project ID
  region         = "us-central1"           # Replace with your preferred region
  service_name   = "my-app"                # Replace with your service name
  alert_email    = "alerts@example.com"    # Replace with your alert email
}

# Cloud Run service
module "cloud_run_service" {
  source = "../../modules/cloud_run_service"
  
  service_name = local.service_name
  region       = local.region
  image_url    = "gcr.io/cloudrun/hello"  # Replace with your image
  
  # Resource limits
  cpu_limit    = "1"
  memory_limit = "512Mi"
  
  # Scaling
  min_instances = 0
  max_instances = 10
  
  # Environment variables
  env_vars = {
    ENV = "development"
  }
  
  allow_public_access = true
}

# Monitoring setup
module "monitoring" {
  source = "../../modules/cloud_run_monitoring"
  
  service_name           = local.service_name
  alert_email           = local.alert_email
  error_rate_threshold  = 5    # 5 errors per minute
  latency_threshold_ms  = 2000 # 2 seconds
}
