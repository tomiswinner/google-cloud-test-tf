# 不要な値が入ってるパターン
function_app = {
  name          = "test-role-001"
  extra_value   = "この値はvariable定義に存在しないためエラーになるはず"
}


# 必要な値が入ってないパターン
# function_app = {
#   extra_value = "この値はvariable定義に存在しないためエラーになるはず"
# }

# 必要な値がないとエラーになる
# │ Error: Invalid value for input variable
# │ 
# │   on terraform.tfvars line 9:
# │    9: function_app = {
# │   10:   extra_value = "この値はvariable定義に存在しないためエラーになるはず"
# │   11: }
# │ 
# │ The given value is not suitable for var.function_app declared at main.tf:1,1-24: attribute "name" is required.
# ╵
