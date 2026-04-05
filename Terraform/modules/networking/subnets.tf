# subnets.tf

# 1. Primary Subnet for IoT Analytics Resources
resource "google_compute_subnetwork" "iot_analytics_subnet" {
  name          = "${var.project_id}-iot-subnet"
  ip_cidr_range = var.subnet_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id

  # Enables private access to Google APIs (BigQuery, Pub/Sub, etc.) 
  # without requiring a public IP for your resources.
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# 2. Serverless VPC Access Connector
# This allows Cloud Functions/Cloud Run to talk to your VPC resources privately.
resource "google_vpc_access_connector" "connector" {
  name          = "iot-vpc-connector"
  region        = var.region
  network       = google_compute_network.vpc_network.name

  # The range must be a /28 and not overlap with existing subnets
  ip_cidr_range = var.vpc_connector_cidr
}