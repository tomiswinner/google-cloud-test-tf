# Service Account for Workflow execution
resource "google_service_account" "workflow_sa" {
  account_id   = "${var.rsc_prefix}-workflow-sa"
  display_name = "Service Account for Workflow execution"
  description  = "Service account used by Google Cloud Workflows"
}

# Service Account for Cloud Run Jobs
resource "google_service_account" "cloudrun_sa" {
  account_id   = "${var.rsc_prefix}-cloudrun-sa"
  display_name = "Service Account for Cloud Run Jobs"
  description  = "Service account used by Cloud Run Jobs"
}

# Cloud Run Job - Hello World
resource "google_cloud_run_v2_job" "hello_world" {
  name     = "${var.rsc_prefix}-hello-world"
  location = var.region

  template {
    template {
      service_account = google_service_account.cloudrun_sa.email
      timeout = "60s"
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.repository_id}/${var.rsc_prefix}-app:latest"
      }
    }
  }
}

# Google Cloud Workflows with service account
resource "google_workflows_workflow" "main" {
  name                = "${var.rsc_prefix}-workflow"
  region              = var.region
  description         = "A workflow that triggers Cloud Run Jobs"
  service_account     = google_service_account.workflow_sa.email
  
  source_contents = <<-YAML
main:
  steps:
  - init:
      assign:
      - job_name: "${google_cloud_run_v2_job.hello_world.name}"
      - location: "${var.region}"
  - trigger_cloudrun_job:
      call: googleapis.run.v2.projects.locations.jobs.run
      args:
        name: $${"projects/${var.project_id}/locations/" + location + "/jobs/" + job_name}
      result: job_execution
  - log_result:
      call: sys.log
      args:
        text: "Cloud Run Job triggered: $${job_execution.name}"
        severity: "INFO"
  - return_result:
      return: $${job_execution}
YAML
}

# https://blog.g-gen.co.jp/entry/how-to-use-iam-resources-of-terraform
# IAM permissions for the workflow service account
resource "google_project_iam_member" "workflow_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

resource "google_project_iam_member" "workflow_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

resource "google_project_iam_member" "workflow_cloudrun_viewer" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}


# IAM permissions for workflow to trigger Cloud Run Jobs
resource "google_project_iam_member" "workflow_cloudrun_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

# IAM permissions for Cloud Run Jobs service account
resource "google_project_iam_member" "cloudrun_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}


# Artifact Registry Repository
resource "google_artifact_registry_repository" "app_repo" {
  location      = var.region
  repository_id = "${var.rsc_prefix}-app-repo"
  description   = "Repository for custom application images"
  format        = "DOCKER"
}

# Cloud Build Service Account
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "${var.rsc_prefix}-cloudbuild-sa"
  display_name = "Service Account for Cloud Build"
  description  = "Service account used by Cloud Build"
}

# IAM permissions for Cloud Build
resource "google_project_iam_member" "cloudbuild_artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}
