# 1. Enable Container API
resource "google_project_service" "container_api" {
  project = var.project_id
  service = "container.googleapis.com"
  disable_on_destroy = false
}

# 2. GKE Autopilot Cluster
# Autopilot is recommended for hands-off management and security best practices.
resource "google_container_cluster" "iot_cluster" {
  name     = "iot-analytics-cluster"
  location = var.region

  # Enabling Autopilot mode
  enable_autopilot = true

  # Networking configuration
  # It's best practice to link this to a VPC (defined in a separate network.tf)
  network    = google_compute_network.iot_vpc.name
  subnetwork = google_compute_subnetwork.iot_subnet.name

  # Setting up a private cluster for security
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # Keep the endpoint public for easier GitHub Actions access
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Cost management: Labels for tracking
  resource_labels = {
    env  = "production"
    component = "iot-processing"
  }

  depends_on = [google_project_service.container_api]
}

# 3. IAM for GKE to interact with Pub/Sub and BigQuery
# GKE uses Workload Identity to securely give pods access to GCP resources
resource "google_service_account" "gke_sa" {
  account_id   = "iot-gke-app-sa"
  display_name = "Service Account for GKE IoT Applications"
}

resource "google_project_iam_member" "gke_pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}