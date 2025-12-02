variable "function_app" {
  description = "厳密な型定義のテスト"
  type = object({
    name = string
    # ここに "extra_value" は定義していないが、object として渡すことは可能（不要な値が入っているオブジェクトでも受け取れる)
  })
}

output "received_name" {
  value = var.function_app.name
}

# ↓は定義してない値なのでエラーになる
# output "received_extra_value" {
#   value = var.function_app.extra_value
# }
