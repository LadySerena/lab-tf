data "google_project" "project" {
}

module "gcs_buckets" {
  source = "terraform-google-modules/cloud-storage/google"
  version = "~> 1.6"
  location = "US"
  project_id = data.google_project.project.project_id
  names = [
    "deb-repo"]
  prefix = "tel"
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "4.0.0"

  project_id                  = data.google_project.project.project_id

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ]
}

module "lab-triggers" {
  source = "git::https://github.com/LadySerena/terraform-modules.git//github-push-pr-tag-triggers?ref=0.1.0"
  ownerName = "LadySerena"
  repoName = "lab-tf"
  project_id = data.google_project.project.project_id
}

module "prometheus-deb-triggers" {
  source = "git::https://github.com/LadySerena/terraform-modules.git//github-push-pr-tag-triggers?ref=0.1.0"
  ownerName = "LadySerena"
  ciDevPath = "ci/feature/cloudbuild.yaml"
  ciMainPath = "ci/release/cloudbuild.yaml"
  repoName = "prometheus-deb"
  project_id = data.google_project.project.project_id
}