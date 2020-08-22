provider "google" {
  project = "telvanni-lab"
  region  = "us-central1"
  version = "~> 3.34"
  zone    = "us-central1-c"
}
provider "google-beta" {
  project = "telvanni-lab"
  region  = "us-central1"
  zone    = "us-central1-c"
  version = "~> 3.35"
}
