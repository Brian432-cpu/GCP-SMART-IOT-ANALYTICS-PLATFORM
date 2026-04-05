# main.tf (Storage Module)

# 1. Cloud Storage Bucket for Raw Data Backups
resource "google_storage_bucket" "raw_data_landing" {
  name          = "${var.project_id}-iot-raw-data"
  location      = var.region
  force_destroy = true # Set to false for production to prevent accidental data loss

  uniform_bucket_level_access = true

  # Lifecycle rule to move old data to Coldline storage to save costs
  lifecycle_rule {
    condition {
      age = 90 # days
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  versioning {
    enabled = true
  }
}

# 2. BigQuery Dataset for Structured Analytics
resource "google_bigquery_dataset" "iot_analytics_dataset" {
  dataset_id                  = "iot_analytics_platform"
  friendly_name               = "IoT Analytics Dataset"
  description                 = "Storage for processed IoT sensor data"
  location                    = var.region
  default_table_expiration_ms = null # Keep data indefinitely for historical analysis

  labels = {
    env = "production"
  }
}

# 3. BigQuery Table for Sensor Logs
resource "google_bigquery_table" "sensor_logs" {
  dataset_id = google_bigquery_dataset.iot_analytics_dataset.dataset_id
  table_id   = "sensor_logs"
  deletion_protection = false # Set to true for production

  time_partitioning {
    type  = "DAY"
    field = "timestamp" # Optimizes queries filtering by time
  }

  # Schema defined as a JSON string or external file
  schema = <<EOF
[
  {
    "name": "device_id",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Unique identifier for the IoT device"
  },
  {
    "name": "temperature",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "humidity",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "status",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
}