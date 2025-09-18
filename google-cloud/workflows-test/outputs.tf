output "workflow_name" {
  description = "The name of the created workflow"
  value       = google_workflows_workflow.main.name
}

output "workflow_id" {
  description = "The ID of the created workflow"
  value       = google_workflows_workflow.main.id
}

output "workflow_state" {
  description = "The state of the workflow"
  value       = google_workflows_workflow.main.state
}

output "workflow_uri" {
  description = "The URI of the workflow"
  value       = "https://console.cloud.google.com/workflows/workflow/${var.region}/${google_workflows_workflow.main.name}?project=${var.project_id}"
}

output "service_account_email" {
  description = "The email of the service account used by the workflow"
  value       = google_service_account.workflow_sa.email
}

output "cloudrun_job_name" {
  description = "The name of the Cloud Run Job"
  value       = google_cloud_run_v2_job.hello_world.name
}

output "cloudrun_job_uri" {
  description = "The URI of the Cloud Run Job"
  value       = "https://console.cloud.google.com/run/jobs/${var.region}/${google_cloud_run_v2_job.hello_world.name}?project=${var.project_id}"
}
