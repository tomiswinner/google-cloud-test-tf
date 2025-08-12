

locals {
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

# Cloud Storage
resource "google_storage_bucket" "static-website" {
  name = "${var.rsc_prefix}-bucket"
  location = var.region
  force_destroy = true
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  website {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }
  cors {
    origin = ["*"]
    method = ["GET", "HEAD"]
    response_header = ["Content-Type"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_object" "index_html" {
  name = "index.html"
  bucket = google_storage_bucket.static-website.name
  source = "./index.html"
  content_type = "text/html"
}

# 対象の bucket の role に対してメンバーを追加
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.static-website.name
  role = "roles/storage.objectViewer"
  member = "allUsers"
}




# load
