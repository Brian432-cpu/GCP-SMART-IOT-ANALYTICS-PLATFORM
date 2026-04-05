# firewall.tf

# 1. Deny all ingress traffic by default (Best Practice)
# Note: GCP has an implicit allow-egress and deny-ingress, 
# but being explicit helps with security audits.

# 2. Allow SSH access only from specialized IP ranges (e.g., Identity-Aware Proxy)
resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "${var.project_id}-allow-ssh-iap"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # This range belongs to Google Cloud IAP
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-ssh"]
}

# 3. Allow internal communication within the VPC
resource "google_compute_firewall" "allow_internal_traffic" {
  name        = "${var.project_id}-allow-internal"
  description = "Allow communication between instances on the same network"
  network     = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.vpc_cidr_range]
}

# 4. Allow Health Checks (Required if you use Load Balancers for an API gateway)
resource "google_compute_firewall" "allow_health_checks" {
  name    = "${var.project_id}-allow-health-checks"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # Google Cloud health check IP ranges
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["load-balanced-backend"]
}