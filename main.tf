terraform {
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

# --- Rede customizada (G5) ---
resource "google_compute_network" "vpc" {
  name                    = "${var.network_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# --- Firewall: SSH liberado só do seu IP (G5) ---
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip_cidr]
  target_tags   = ["ssh-allowed"]
}

# --- Firewall: HTTP restrito à sua rede (não mais público) ---
resource "google_compute_firewall" "allow_http" {
  name    = "${var.network_name}-allow-http"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80", "9090", "3000", "9100"]
  }

  source_ranges = [var.my_ip_cidr]
  target_tags   = ["http-server"]
}

# --- IP externo estático (não muda em reboot/recreate) ---
resource "google_compute_address" "static_ip" {
  name   = "${var.instance_name}-ip"
  region = var.region
}

# --- Instância e2-micro Always Free (G6) ---
resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["ssh-allowed", "http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30 # GB — dentro do limite Always Free
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = var.startup_script

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}
