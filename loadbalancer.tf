## backend backet
resource "google_compute_backend_bucket" "static-website-backend" {
  name = "${var.rsc_prefix}-backend"
  bucket_name = google_storage_bucket.static-website.name
  enable_cdn = true
}

## url map
### ちょっとオプションがいろいろ多すぎるので網羅してない
### これも alb のみ（というか http/https proxy の裏側）
resource "google_compute_url_map" "static_website_urlmap" {
  name            = "${var.rsc_prefix}-urlmap"
  default_service = google_compute_backend_bucket.static-website-backend.id
  # default ではなく　　host ヘッダーで振り分けたい場合　↓, path matcher と紐付けて利用する
  ## マルチドメイン(SNI を利用したサブドメインでわけるケース)
  # host_rule {
  #   hosts = ["*"]
  #   path_matcher = "${var.rsc_prefix}-path-matcher"
  # }
  # path_matcher {
  #   name = "${var.rsc_prefix}-path-matcher"
  #   default_service = google_compute_backend_bucket.static-website-backend.id
  #   path_rule {
  #     paths = ["/home"]
  #     service = google_compute_backend_bucket.static-website-backend.id
  #   }
  # }
}

### url map health check
# resource "google_compute_health_check" "static-website-health-check" {
#   name = "${var.rsc_prefix}-health-check"
#   http_health_check {
#     request_path = "/"
#   }
# }

## HTTP/HTTPS proxy 
### ALB の場合はこれを利用する
resource "google_compute_target_http_proxy" "static-website-proxy" {
  name = "${var.rsc_prefix}-proxy"
  url_map = google_compute_url_map.static_website_urlmap.id
  # http_keep_alive_timeout_sec = 610 # loab balancer によってデフォルト値・クォータ違うので注意
  # proxy_bind = true  # これは gwlb みたいなサードパーティ製品を vpc 上で動かしてパケット精査をしたい場合ぽい
}

## forwarding rule
### こちらもオプション多すぎて精査できず
resource "google_compute_global_forwarding_rule" "static-website-proxy" {
  name = "${var.rsc_prefix}-forwarding-rule"
  target = google_compute_target_http_proxy.static-website-proxy.id
  port_range = "80"
  ip_protocol = "TCP"
  ip_version = "IPV4"
  load_balancing_scheme = "EXTERNAL_MANAGED" # MANAGED は　ｔｌｓ終端, path routing とかをやってくれる（= ALB)、managed でない = NLB
  # source_ip_ranges = ["0.0.0.0/0"] # ip 制限が waf なしでもできる, ただし regional のみぽい、、
  # source_ip_ranges : this field can only be used with a regional Forwarding Rule whose scheme is EXTERNAL
  # metadata_filters  # Envoy っていう特殊なユースケースで利用する
  # network # internal LB のみ

}
