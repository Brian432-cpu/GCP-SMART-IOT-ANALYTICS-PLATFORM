# Root variables.tf

# --- Project Configuration ---

variable "project_id" {
  description = "The GCP Project ID where resources will be deployed"
  type        = string
}

variable "region" {
  description = "The primary GCP region for all resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The primary GCP zone for compute resources"
  type        = string
  default     = "us-central1-a"
}

# --- Networking Module Variables ---

variable "vpc_cidr_range" {
  description = "The CIDR range for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_range" {
  description = "The CIDR range for the IoT analytics subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vpc_connector_cidr" {
  description = "The /28 CIDR range for the Serverless VPC Access Connector"
  type        = string
  default     = "10.8.0.0/28"
}

# --- Storage Module Variables ---

variable "bigquery_dataset_id" {
  description = "The ID for the BigQuery dataset"
  type        = string
  default     = "iot_analytics_platform"
}

variable "storage_class" {
  description = "The default storage class for the GCS bucket"
  type        = string
  default     = "STANDARD"
}

# --- Environment Tagging ---

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}