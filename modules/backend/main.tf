resource "google_cloud_run_service" "backend" {
  name = "${var.rsc_prefix}-backend"
  location = var.region
  template {
    spec {
      # TIPS: cloud run は http 8080 とかで待ち受けないと http server のヘルスチェック失敗で落ちるI
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello" # テスト用のイメージあるんだ神
      }
    }
  }
}

# 全てのユーザーに対して、Cloud Run の invoker 権限を付与するポリシー
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# 今回の Cloud Run に対してポリシーを適用
resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.backend.location
  project     = google_cloud_run_service.backend.project
  service     = google_cloud_run_service.backend.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
