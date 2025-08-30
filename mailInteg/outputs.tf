output "workflow_name" {
  description = "Name of the manual trigger workflow"
  value       = google_workflows_workflow.manual_workflow.name
}

output "workflow_execution_url" {
  description = "URL to execute the workflow manually"
  value       = "https://console.cloud.google.com/workflows/workflow/${google_workflows_workflow.manual_workflow.name}/executions?project=${var.project_id}"
}

output "pubsub_topic_name" {
  description = "Name of the Pub/Sub topic"
  value       = google_pubsub_topic.workflow_topic.name
}

output "pubsub_subscription_name" {
  description = "Name of the Pub/Sub subscription"
  value       = google_pubsub_subscription.workflow_subscription.name
}
