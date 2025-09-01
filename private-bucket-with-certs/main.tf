locals {
  load_balancing_scheme = "EXTERNAL_MANAGED"
  exectutor-id = "1234"
  # MIMEタイプのマッピング
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".woff" = "font/woff"
    ".woff2" = "font/woff2"
  }
}

# -----------------------------
# Cloud Storage: private bucket
# -----------------------------
resource "google_storage_bucket" "private" {
  name          = "${var.rsc_prefix}-taktak-private-bucket"
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true
  website {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }

  # 必要に応じて Cache-Control を付ける（例）
  # default_event_based_hold = false
}

# outディレクトリ全体をアップロード
resource "google_storage_bucket_object" "static_files" {
  for_each = fileset("${path.module}/../nextjs-sample-site/out", "**/*")
  
  name = each.value
  bucket = google_storage_bucket.private.name
  source = "${path.module}/../nextjs-sample-site/out/${each.value}"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}

# SA を作成し、Object Viewer を付与（最小権限）
resource "google_service_account" "cdn_sa" {
  account_id   = "${var.rsc_prefix}-cdn-origin-sa"
  display_name = "CDN origin access SA"
}

resource "google_storage_bucket_iam_member" "sa_obj_viewer" {
  bucket = google_storage_bucket.private.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cdn_sa.email}"
}

# HMAC キー発行（XML API 用）
resource "google_storage_hmac_key" "hmac" {
  service_account_email = google_service_account.cdn_sa.email
  project               = var.project_id
  state                 = "ACTIVE"
  # 注意: secret は state に入るため、Remote State の暗号化や権限管理は必須
}

# -----------------------------
# Internet NEG (global, FQDN:PORT)
# -----------------------------
resource "google_compute_global_network_endpoint_group" "gcs_neg" {
  name                  = "${var.rsc_prefix}-neg-gcs-${google_storage_bucket.private.name}"
  network_endpoint_type = "INTERNET_FQDN_PORT"
}

resource "google_compute_global_network_endpoint" "gcs_endpoint" {
  global_network_endpoint_group = google_compute_global_network_endpoint_group.gcs_neg.name
  fqdn       = "${google_storage_bucket.private.name}.storage.googleapis.com"
  port       = 443
}

# -----------------------------
# Backend Service (HTTP(S) LB, CDN 有効)
# -----------------------------
resource "google_compute_backend_service" "gcs_bs" {
  name                  = "${var.rsc_prefix}-bs-gcs-${google_storage_bucket.private.name}"
  protocol              = "HTTPS"
  load_balancing_scheme = local.load_balancing_scheme
  enable_cdn            = true

  # キャッシュ方針（private bucket のデフォは cache しない挙動なので上書き）
  cdn_policy {
  cache_mode  = "CACHE_ALL_STATIC" # or USE_ORIGIN_HEADERS
  default_ttl = 3600
  client_ttl  = 3600
  max_ttl     = 86400

  # ← これを追加（最低限でOK）
  cache_key_policy {
    include_host          = true
    include_protocol      = true
    include_query_string  = false   # パラメータで分けたいなら true にして whitelist 等を設定
    # query_string_whitelist = ["v","lang"]  # 例
  }
}

  log_config {
    enable = true
  }

  backend {
    group = google_compute_global_network_endpoint_group.gcs_neg.id
  }

  # Health check は Internet NEG では省略可（GFE 側で監視）。必要なら HTTPS HC を別途追加。
}

# -----------------------------
# URL Map: Host ヘッダ付与 & Cookie 削除
# -----------------------------

# route_rule と path_rule がある
## path_rule はシンプルなルーティングをする場合に使う
## route_rule は複雑なルーティングをする場合に使う, classic ではサポートされてないらしい, External LB = Classic てのがややこしい
## https://discuss.google.dev/t/what-is-the-difference-between-routerules-and-pathrules-in-a-url-map/164115/

# TODO: ルーティングは　Next に特化されてないが、動的にコンテンツが増えるようなケース（動的パス）では SSG はまず使われない(際デプロイが必要になっちゃうので)
resource "google_compute_url_map" "urlmap" {
  name            = "${var.rsc_prefix}-umap-gcs-${google_storage_bucket.private.name}"
  default_service = google_compute_backend_service.gcs_bs.id

  host_rule {
    hosts = ["*"]
    path_matcher = "${var.rsc_prefix}-path-matcher"
  }
  default_route_action {
    url_rewrite {
      host_rewrite = "${google_storage_bucket.private.name}.storage.googleapis.com"
      path_prefix_rewrite = "/index.html"
    }
  }

  path_matcher {
    name = "${var.rsc_prefix}-path-matcher"
    default_service = google_compute_backend_service.gcs_bs.id

    path_rule {
      paths = ["/*"]
      service = google_compute_backend_service.gcs_bs.id
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/index.html"
          host_rewrite = "${google_storage_bucket.private.name}.storage.googleapis.com"
        }
      }
    }
  }
}

# -----------------------------
# Frontend: HTTP (80) の最小構成
# -----------------------------
resource "google_compute_global_address" "lb_ip" {
  name = "${var.rsc_prefix}-ip-gcs-${google_storage_bucket.private.name}"
  depends_on = [google_compute_url_map.urlmap]
}

resource "google_compute_target_https_proxy" "proxy" {
  name    = "${var.rsc_prefix}-thp-gcs-${google_storage_bucket.private.name}"
  url_map = google_compute_url_map.urlmap.id
  ssl_certificates = [ google_compute_managed_ssl_certificate.certificate.id ]
  
}

resource "google_compute_global_forwarding_rule" "http_fr" {
  name                  = "${var.rsc_prefix}-fr-http-gcs-${google_storage_bucket.private.name}"
  ip_address            = google_compute_global_address.lb_ip.address
  port_range            = "80"
  target                = google_compute_target_https_proxy.proxy.id
  load_balancing_scheme = local.load_balancing_scheme
}

# -----------------------------
# SigV4 認証の注入（未サポ環境でも通すための PATCH）
# -----------------------------
resource "null_resource" "patch_backend_service_sigv4" {
  # trigger に指定したプロパティが変更になると実行される
  triggers = {
    backend_service = google_compute_backend_service.gcs_bs.id
    access_id       = google_storage_hmac_key.hmac.access_id
    # secret は変わると「再 PATCH」が必要なので trigger に含める
    secret_digest   = sha256(google_storage_hmac_key.hmac.secret)
    origin_region   = var.region
    executor_id     = local.exectutor-id
  }

# Google の Cloud CDN Private Origin 認証 (SigV4) を有効化する部分, これは terraform ではできないので、null_resource で実行する
## https://cloud.google.com/cdn/docs/configure-private-origin-authentication#api
  provisioner "local-exec" {
    command = "${path.module}/update_backend_service.sh $PROJECT_ID $BACKEND_SERVICE_NAME $ACCESS_ID $SECRET $ORIGIN_REGION"
    environment = {
      PROJECT_ID = var.project_id
      BACKEND_SERVICE_NAME = google_compute_backend_service.gcs_bs.name
      ACCESS_ID = google_storage_hmac_key.hmac.access_id
      SECRET = google_storage_hmac_key.hmac.secret
      ORIGIN_REGION = var.region
    }
  }

  depends_on = [
    google_compute_backend_service.gcs_bs,
    google_storage_hmac_key.hmac
  ]
}

output "lb_ip" {
  value = google_compute_global_address.lb_ip.address
}

# -----------------------------
# Custom Domain
# -----------------------------

# 自動で certificate manager で管理される
## google_certificate_manager_certificate は、よりリッチな機能を使うための証明書
## google_compute_managed_ssl_certificate は LB などに使える証明書で、基本はこっちでいいはず
### 実体が作成されると、デプロイ完了となるが DNS 認証とかが完了しないと使えない : https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate
resource "google_compute_managed_ssl_certificate" "certificate" {
  name = "${var.rsc_prefix}-cert-gcs-${google_storage_bucket.private.name}"
  managed {
    domains = ["hogehoge.test.mmmcorp.co.jp"]
  }
}

# Cloud DNS : https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone
resource "google_dns_managed_zone" "dns_zone" {
  name = "hogehoge-test"
  dns_name = "hogehoge.test.mmmcorp.co.jp."
  visibility = "public"
}
resource "google_dns_record_set" "lb_a_record" {
  name = "hogehoge.test.mmmcorp.co.jp."
  type = "A"
  ttl = 30
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas = [google_compute_global_address.lb_ip.address] # rr = Resource Record : 種類に応じた DNS record に格納する値、A なら ip address
}
