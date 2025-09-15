# Terraform は「モジュールはブラックボックス」扱いなので、ouput 出す
output "service_name" {
  value = google_cloud_run_service.backend.name
}
