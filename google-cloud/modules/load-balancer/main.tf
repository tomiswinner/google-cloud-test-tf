# load balancer module




## backend backet
resource "google_compute_backend_bucket" "static-website-backend" {
  name = "${var.rsc_prefix}-backend"
  bucket_name = var.backend_bucket_name
  enable_cdn = true
}

# cloud run との統合 : https://cloud.google.com/load-balancing/docs/https/ext-http-lb-tf-module-examples?hl=ja#with_a_backend
# 今は neg での書き方が主流っぽいなぁ、、、
## serverless NEG
resource "google_compute_region_network_endpoint_group" "static-website-backend" {
  name = "${var.rsc_prefix}-backend"
  region = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.backend_service_name
  }
}


## backend service for cloud run (using NEG)
resource "google_compute_backend_service" "cloud-run-backend" {
  name = "${var.rsc_prefix}-cloud-run-backend"
  protocol = "HTTP"
  port_name = "http"
  timeout_sec = 30
  load_balancing_scheme = var.load_balancing_scheme
  # health_checks = [google_compute_health_check.static-website-health-check.id] # NEG は自動でヘルスチェックするから不要らしい?
  backend {
    group = google_compute_region_network_endpoint_group.static-website-backend.id
  }
}



## url map
### ちょっとオプションがいろいろ多すぎるので網羅してない
### これも alb のみ（というか http/https proxy の裏側）
resource "google_compute_url_map" "static_website_urlmap" {
  name            = "${var.rsc_prefix}-urlmap"
  default_service = google_compute_backend_bucket.static-website-backend.id
  # default ではなく　　host ヘッダーで振り分けたい場合　↓, path matcher と紐付けて利用する
  ## マルチドメイン(SNI を利用したサブドメインでわけるケース)
  host_rule {
    hosts = ["*"]
    path_matcher = "${var.rsc_prefix}-path-matcher"
  }

  path_matcher {
    name = "${var.rsc_prefix}-path-matcher"
    default_service = google_compute_backend_bucket.static-website-backend.id
    path_rule {
      paths = ["/home"]
      service = google_compute_backend_bucket.static-website-backend.id
    }
    path_rule {
      paths = ["/api/*"]
      service = google_compute_backend_service.cloud-run-backend.id
      route_action {
        url_rewrite {
          # host_rewrite = # 不要
          path_prefix_rewrite = "/"
        }
      }
      ## url redirect は 301 とかのリダイレクトなので　パス書き換えとは別
      # url_redirect {
      #   # host_redirect = "www.example.com"  # ホスト名リダイレクトは不要
      #   path_redirect = "/"
      #   https_redirect = false
      #   strip_query = true
      # }
    }
  }
}

### url map health check
resource "google_compute_health_check" "static-website-health-check" {
  name = "${var.rsc_prefix}-health-check"
  http_health_check {
    request_path = "/"
  }
}

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
  load_balancing_scheme = var.load_balancing_scheme # MANAGED は　ｔｌｓ終端, path routing とかをやってくれる（= ALB)、managed でない = NLB
  # source_ip_ranges = ["0.0.0.0/0"] # ip 制限が waf なしでもできる, ただし regional のみぽい、、
  # source_ip_ranges : this field can only be used with a regional Forwarding Rule whose scheme is EXTERNAL
  # metadata_filters  # Envoy っていう特殊なユースケースで利用する
  # network # internal LB のみ

}
