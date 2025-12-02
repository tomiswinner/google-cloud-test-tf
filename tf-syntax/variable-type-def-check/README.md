# Terraform Variable Type Definition Check

## 検証内容

`variable` で `object` 型を定義した際の挙動を検証。

### 結果

- **定義されていないキーを含むオブジェクトを渡す**: エラーにならない（不要な値は無視される）
- **定義されている必須キーがないオブジェクトを渡す**: エラーになる
- **定義されていないキーにアクセスする**: エラーになる

## 検証方法

```bash
terraform init
terraform validate
```
