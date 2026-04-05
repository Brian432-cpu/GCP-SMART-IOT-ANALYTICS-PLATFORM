# outputs.tf

output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "network_self_link" {
  description = "The URI of the VPC network"
  value       = google_compute_network.vpc_network.self_link
}

output "subnet_name" {
  description = "The name of the created subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_region" {
  description = "The region where the subnet is located"
  value       = google_compute_subnetwork.subnet.region
}

output "vpc_connector_id" {
  description = "The ID of the Serverless VPC Access connector for Cloud Functions"
  value       = google_vpc_access_connector.connector.id
}

output "firewall_rule_internal_name" {
  description = "The name of the internal traffic firewall rule"
  value       = google_compute_firewall.allow_internal_traffic.name
}