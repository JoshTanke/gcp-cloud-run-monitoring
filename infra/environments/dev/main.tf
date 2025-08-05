
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  backend "gcs" {
    bucket = "infra-new-state"
    prefix = "examples/cloud-run-monitoring"
  }
}

provider "google" {
  project = "launchflow-services-dev"
  region  = "us-central1"
}

locals {
  service_name = "my-app"
  alert_email  = "alerts@launchflow.com"
}

# Cloud Run service
module "cloud_run_service" {
  source = "../../modules/cloud_run_service"
  
  service_name = local.service_name
  region       = "us-central1"
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
