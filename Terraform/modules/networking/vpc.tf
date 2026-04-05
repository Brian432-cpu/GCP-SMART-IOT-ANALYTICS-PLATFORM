# vpc.tf

# 1. The Virtual Private Cloud (VPC)
resource "google_compute_network" "vpc_network" {
  name                            = "${var.project_id}-vpc"
  auto_create_subnetworks         = false # Custom mode is preferred for production
  routing_mode                    = "REGIONAL"
  mtu                             = 1460 # Standard Maximum Transmission Unit
  delete_default_routes_on_create = false

  description = "Primary VPC for the Smart IoT Analytics Platform"
}

# 2. Project-wide Network Tier (Optional but recommended)
# Standard Tier is usually sufficient for IoT, Premium is for global low-latency.
resource "google_compute_project_default_network_tier" "default" {
  network_tier = "PREMIUM"
}

# 3. Google Services Private Access (Service Networking)
# This allows your VPC to connect to Google managed services like Cloud SQL 
# or Memorystore (Redis) using private IP addresses.
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "${var.project_id}-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}