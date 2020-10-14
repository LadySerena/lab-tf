data "google_compute_image" "base_image" {
  family  = "tel-base-debian-10"
  project = "telvanni-platform"
}

data "google_compute_network" "default_network" {
  name = "default"
}

# resource "google_compute_instance" "test" {
#   name                      = "disk-test-2"
#   machine_type              = "f1-micro"
#   allow_stopping_for_update = true
#   zone                      = "us-central1-a"
#   metadata = {
#     mount-point        = "/mc-data"
#     owner              = "nodeExporter"
#     disk-id            = "test"
#     volume-group-name  = "auto-vg"
#     lvm-name           = "auto-lvm"
#     startup-script-url = "gs://${module.gcs_buckets.names_list[1]}/${google_storage_bucket_object.startup-script.name}"
#   }
#   boot_disk {
#     initialize_params {
#       image = data.google_compute_image.base_image.self_link
#     }
#   }
#   network_interface {
#     network = data.google_compute_network.default_network.name
#     access_config {

#     }
#   }
#   attached_disk {
#     source      = google_compute_disk.test-disk.self_link
#     device_name = "test"
#   }
#   service_account {
#     scopes = [
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/monitoring.write",
#       "https://www.googleapis.com/auth/logging.write",
#     ]
#   }
# }

# resource "google_compute_disk" "test-disk" {
#   name = "test"
#   type = "pd-standard"
#   zone = "us-central1-a"
#   size = 50
# }


resource "google_compute_firewall" "allow-icmp-iap-ssh" {
  name    = "allow-icmp-iap-ssh"
  network = data.google_compute_network.default_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = [
  "35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports = [
    "22"]

  }
  priority = 1000
}
