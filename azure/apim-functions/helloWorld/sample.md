# HelloWorld Function API 定義

## レスポンスサンプル

### 成功レスポンス

```json
{
  "message": "Hello World"
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

## API Management 向け API 定義

### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "message": {
            "type": "string",
            "description": "Hello World メッセージを返却します。"
        }
    },
    "required": ["message"]
}
```

### API Management ポリシー例

```xml
<policies>
  <inbound>
    <base />
    <set-backend-service base-url="https://az-di-dev-jpe-func-taktest-002-single-get-f9emgvbyc8gucqgx.japaneast-01.azurewebsites.net" />
    <rewrite-uri template="/api/HelloWorld" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
    <set-header name="Content-Type" exists-action="override">
      <value>application/json; charset=utf-8</value>
    </set-header>
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
```

