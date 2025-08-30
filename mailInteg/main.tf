# workflows : trigger は手動
## 手動 trigger から pub/sub を trigger して、 application integration を trigger する


# Pub/Sub Topic
resource "google_pubsub_topic" "workflow_topic" {
  name = "workflow-trigger-topic"
}

# Pub/Sub Subscription
resource "google_pubsub_subscription" "workflow_subscription" {
  name  = "workflow-trigger-subscription"
  topic = google_pubsub_topic.workflow_topic.name
}

# Cloud Workflows
resource "google_workflows_workflow" "manual_workflow" {
  name            = "manual-trigger-workflow"
  region          = var.region
  description     = "Workflow that can be manually triggered to publish to Pub/Sub"
  service_account = google_service_account.workflow_service_account.email
  
  source_contents = templatefile("${path.module}/workflow.yaml.tftpl", {
    TOPIC_FULL_PATH = "projects/${var.project_id}/topics/${google_pubsub_topic.workflow_topic.name}"
  })
}

# IAM for Workflows to publish to Pub/Sub
resource "google_project_iam_member" "workflow_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.workflow_service_account.email}"
}

# Service Account for Workflows
resource "google_service_account" "workflow_service_account" {
  account_id   = "workflow-sa"
  display_name = "Service Account for Workflows"
}





