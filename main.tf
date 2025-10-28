provider "google" {
  credentials = base64decode(var.gcp_credentials)
  project     = var.project_id
  region      = var.region
}

#Generate SSH Key Pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#Save Private Key Locally
resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/my_gcp_key.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

#Save Public Key Locally
resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/my_gcp_key.pub"
}


resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = "true"
  
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnetwork_ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.self_link

  depends_on    = [ google_compute_network.vpc_network ]
}

resource "google_compute_firewall" "n8n_firewall" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22","80","443","5432","5678"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "n8n_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnetwork.self_link
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh_key.public_key_openssh}"
  }

  metadata_startup_script = file("docker.sh")

}

