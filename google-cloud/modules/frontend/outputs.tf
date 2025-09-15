# Terraform は「モジュールはブラックボックス」扱いなので、ouput 出す
output "bucket_name" {
  value = google_storage_bucket.static-website.name
}
