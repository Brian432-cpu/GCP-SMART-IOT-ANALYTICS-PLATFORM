# variables.tf (Storage Module)

variable "project_id" {
  description = "The GCP project ID where the storage resources will be created"
  type        = string
}

variable "region" {
  description = "The GCP region for the GCS bucket and BigQuery dataset"
  type        = string
  default     = "us-central1"
}

variable "dataset_id" {
  description = "The unique ID for the BigQuery dataset"
  type        = string
  default     = "iot_analytics_platform"
}

variable "table_id" {
  description = "The ID of the main BigQuery table for sensor data"
  type        = string
  default     = "sensor_logs"
}

variable "bucket_name_suffix" {
  description = "Suffix to append to the GCS bucket name to ensure global uniqueness"
  type        = string
  default     = "raw-data-landing"
}

variable "storage_class" {
  description = "The Storage Class of the new bucket"
  type        = string
  default     = "STANDARD"
}

variable "delete_contents_on_destroy" {
  description = "Whether to allow Terraform to delete the bucket even if it contains objects"
  type        = bool
  default     = false
}