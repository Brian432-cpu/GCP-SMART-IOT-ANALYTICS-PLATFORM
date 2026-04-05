# 1. Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 2. Networking & Storage for Cloud Functions
resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-gcf-source"
  location = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

# 3. Pub/Sub Topics (The Messaging Backbone)
resource "google_pubsub_topic" "iot_raw_data" {
  name = "iot-raw-data"
}

# 4. BigQuery Analytics Layer
resource "google_bigquery_dataset" "iot_dataset" {
  dataset_id                  = "iot_analytics_ds"
  friendly_name               = "IoT Analytics Dataset"
  description                 = "Storage for enriched IoT telemetry"
  location                    = var.region
  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "enriched_telemetry" {
  dataset_id = google_bigquery_dataset.iot_dataset.dataset_id
  table_id   = "enriched_telemetry"
  deletion_protection = false

  time_partitioning {
    type = "DAY"
    field = "timestamp"
  }

  schema = <<EOF
[
  {"name": "timestamp", "type": "TIMESTAMP", "mode": "REQUIRED"},
  {"name": "device_id", "type": "STRING", "mode": "REQUIRED"},
  {"name": "temperature", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "humidity", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "status", "type": "STRING", "mode": "NULLABLE"},
  {"name": "region", "type": "STRING", "mode": "NULLABLE"},
  {"name": "alert_level", "type": "STRING", "mode": "NULLABLE"},
  {"name": "processed_at", "type": "TIMESTAMP", "mode": "NULLABLE"}
]
EOF
}

# 5. Service Account for Cloud Functions
resource "google_service_account" "function_sa" {
  account_id   = "iot-processor-sa"
  display_name = "Service Account for IoT Cloud Functions"
}

# Grant BigQuery Data Editor to the Service Account
resource "google_project_iam_member" "bq_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}

# Grant Pub/Sub Publisher/Subscriber roles
resource "google_project_iam_member" "pubsub_admin" {
  project = var.project_id
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}