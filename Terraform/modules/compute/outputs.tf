# 1. GKE Cluster Details
output "kubernetes_cluster_name" {
  value       = google_container_cluster.iot_cluster.name
  description = "The name of the GKE Autopilot cluster"
}

output "kubernetes_cluster_endpoint" {
  value       = google_container_cluster.iot_cluster.endpoint
  description = "The IP address of the GKE cluster master"
  sensitive   = true
}

output "kubernetes_cluster_ca_certificate" {
  value       = google_container_cluster.iot_cluster.master_auth[0].cluster_ca_certificate
  description = "The public certificate of the GKE cluster"
  sensitive   = true
}

# 2. Service Account Details
output "gke_service_account_email" {
  value       = google_service_account.gke_sa.email
  description = "The email of the service account used by GKE workloads"
}

# 3. Location Details
output "cluster_location" {
  value       = google_container_cluster.iot_cluster.location
  description = "The GCP region/zone where the cluster is deployed"
}

# 4. Workload Identity Configuration
# Useful for configuring K8s service accounts to mimic GCP IAM roles
output "workload_identity_pool" {
  value       = "${var.project_id}.svc.id.goog"
  description = "The Workload Identity pool for the project"
}