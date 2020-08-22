terraform {
  backend "gcs" {
    bucket = "state-tel"
    prefix = "terraform/state"
  }
}
