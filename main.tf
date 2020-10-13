data "google_project" "project" {
}

module "gcs_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "~> 1.7"
  location   = "US"
  project_id = data.google_project.project.project_id
  names = [
    "deb-repo",
    "lab-metadata"
  ]
  set_viewer_roles = true
  bucket_viewers = {
    lab-metadata = "serviceAccount:952032963423-compute@developer.gserviceaccount.com"
  }
  prefix = "tel"
}

resource "google_storage_bucket_object" "startup-script" {
  name = "startup-script.sh"
  bucket = module.gcs_buckets.names_list[1]
  source = "./disk.sh"
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "4.0.0"

  project_id = data.google_project.project.project_id

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbuild.googleapis.com",
  ]
}

module "lab-triggers" {
  source     = "git::https://github.com/LadySerena/terraform-modules.git//github-push-pr-tag-triggers?ref=0.1.0"
  ownerName  = "LadySerena"
  repoName   = "lab-tf"
  project_id = data.google_project.project.project_id
}

module "prometheus-deb-triggers" {
  source     = "git::https://github.com/LadySerena/terraform-modules.git//github-push-pr-tag-triggers?ref=0.1.0"
  ownerName  = "LadySerena"
  ciDevPath  = "ci/feature/cloudbuild.yaml"
  ciMainPath = "ci/release/cloudbuild.yaml"
  repoName   = "prometheus-deb"
  project_id = data.google_project.project.project_id
}

module "project-iam-bindings" {
  source = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [
  data.google_project.project.project_id]
  mode = "additive"

  bindings = {
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:952032963423@cloudbuild.gserviceaccount.com",
    ],
    "roles/iam.securityAdmin" = [
      "serviceAccount:952032963423@cloudbuild.gserviceaccount.com",
    ],
    "roles/compute.networkAdmin" = [
      "serviceAccount:952032963423@cloudbuild.gserviceaccount.com",
    ],
    "roles/compute.securityAdmin" = [
      "serviceAccount:952032963423@cloudbuild.gserviceaccount.com",
    ]
  }
}

