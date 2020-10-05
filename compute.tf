data "google_compute_image" "base_image" {
  family  = "tel-base-debian-10"
  project = "telvanni-platform"
}

data "google_compute_network" "default_network" {
  name = "default"
}

# resource "google_compute_instance" "test" {
#   # name         = "disk-test"
#   # machine_type = "f1-micro"
#   zone         = "us-central1-a"
#   boot_disk {
#     initialize_params {
#       image = data.google_compute_image.base_image.self_link
#     }
#   }
#   network_interface {}
# }


resource "google_compute_firewall" "allow-icmp-iap-ssh" {
  name    = "allow-icmp-iap-ssh"
  network = data.google_compute_network.default_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22"]

  }
  priority = 1000
}
