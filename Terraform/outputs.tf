# Root outputs.tf

# --- Networking Module Outputs ---
output "vpc_name" {
  description = "The name of the VPC created"
  value       = module.networking.network_name
}

output "vpc_connector_id" {
  description = "The ID of the Serverless VPC Connector for Cloud Functions"
  value       = module.networking.vpc_connector_id
}

output "subnet_id" {
  description = "The ID of the IoT primary subnet"
  value       = module.networking.subnet_id
}

# --- Storage Module Outputs ---
output "bigquery_table_id" {
  description = "The BigQuery table where IoT data will be stored"
  value       = module.storage.sensor_table_id
}

output "raw_data_bucket_name" {
  description = "The GCS bucket name for raw telemetry storage"
  value       = module.storage.raw_data_bucket_name
}

# --- Project Summary ---
output "project_id" {
  description = "The GCP Project ID being managed"
  value       = var.project_id
}

output "region" {
  description = "The primary region for the IoT Platform"
  value       = var.region
}