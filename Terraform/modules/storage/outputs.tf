# outputs.tf (Storage Module)

# --- Cloud Storage Outputs ---

output "raw_data_bucket_name" {
  description = "The name of the GCS bucket for raw data"
  value       = google_storage_bucket.raw_data_landing.name
}

output "raw_data_bucket_url" {
  description = "The base URL of the GCS bucket"
  value       = google_storage_bucket.raw_data_landing.url
}

# --- BigQuery Outputs ---

output "bigquery_dataset_id" {
  description = "The ID of the BigQuery dataset"
  value       = google_bigquery_dataset.iot_analytics_dataset.dataset_id
}

output "bigquery_dataset_id_full" {
  description = "The fully qualified ID of the dataset (project:dataset)"
  value       = google_bigquery_dataset.iot_analytics_dataset.id
}

output "sensor_table_id" {
  description = "The ID of the BigQuery table for sensor data"
  value       = google_bigquery_table.sensor_logs.table_id
}

output "sensor_table_ref" {
  description = "The unique ID for the BigQuery table"
  value       = google_bigquery_table.sensor_logs.id
}