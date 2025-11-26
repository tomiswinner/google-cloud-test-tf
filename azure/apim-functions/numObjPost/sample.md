# numObjPost Function API 定義

## NumberPost API

### リクエスト

**HTTP メソッド:** `POST`

**Content-Type:** `application/json`

**リクエストボディ:**

```json
42
```

または

```json
{
  "value": 42
}
```

### レスポンスサンプル

```json
{
  "value": 42
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

### API Management 向け API 定義

#### リクエストスキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "number",
    "description": "数値を指定します。"
}
```

#### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "number",
            "description": "受け取った数値を返却します。"
        }
    },
    "required": ["value"]
}
```

---

## ObjectPost API

### リクエスト

**HTTP メソッド:** `POST`

**Content-Type:** `application/json`

**リクエストボディ:**

```json
{
  "data": {
    "string": "test",
    "integer": 42
  }
}
```

### レスポンスサンプル

```json
{
  "data": {
    "string": "test",
    "integer": 42
  }
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

### API Management 向け API 定義

#### リクエストスキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "data": {
            "type": "object",
            "description": "任意。データオブジェクトを指定します。",
            "properties": {
                "string": {
                    "type": "string",
                    "description": "任意。文字列を指定します。"
                },
                "integer": {
                    "type": "integer",
                    "description": "任意。整数を指定します。"
                }
            }
        }
    }
}
```

#### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "data": {
            "type": "object",
            "description": "受け取ったデータオブジェクトを返却します。",
            "properties": {
                "string": {
                    "type": "string",
                    "description": "受け取った文字列を返却します。"
                },
                "integer": {
                    "type": "integer",
                    "description": "受け取った整数を返却します。"
                }
            }
        }
    }
}
```

---

## BoolPost API

### リクエスト

**HTTP メソッド:** `POST`

**Content-Type:** `application/json`

**リクエストボディ:**

```json
{
  "value": true
}
```

### レスポンスサンプル

```json
{
  "value": true
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

### API Management 向け API 定義

#### リクエストスキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "boolean",
    "description": "真偽値を指定します。"
}
```

#### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "boolean",
            "description": "受け取った真偽値を返却します。"
        }
    },
    "required": ["value"]
}
```

---

## ArrPost API

### リクエスト

**HTTP メソッド:** `POST`

**Content-Type:** `application/json`

**リクエストボディ:**

```json
{
  "value": ["apple", "banana", "cherry"]
}
```

### レスポンスサンプル

```json
{
  "value": ["apple", "banana", "cherry"]
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

### API Management 向け API 定義

#### リクエストスキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "array",
    "items": {
        "type": "string"
    },
    "description": "文字列配列を指定します。"
}
```

#### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "array",
            "items": {
                "type": "string"
            },
            "description": "受け取った文字列配列を返却します。"
        }
    },
    "required": ["value"]
}
```

---

## Delete API

### リクエスト

**HTTP メソッド:** `DELETE`

**Content-Type:** `application/json`

**リクエストボディ:**

```json
{
  "value": "test string"
}
```

### レスポンスサンプル

```json
{
  "value": "test string"
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

### API Management 向け API 定義

#### リクエストスキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "string",
            "description": "任意。文字列を指定します。"
        }
    }
}
```

#### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "string",
            "description": "受け取った文字列を返却します。"
        }
    }
}
```

---

## Patch API

### リクエスト

**HTTP メソッド:** `PATCH`

**Content-Type:** `application/json`

**リクエストボディ:**

```json
{
  "value": "test string"
}
```

### レスポンスサンプル

```json
{
  "value": "test string"
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

### API Management 向け API 定義

#### リクエストスキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "string",
            "description": "任意。文字列を指定します。"
        }
    }
}
```

#### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "string",
            "description": "受け取った文字列を返却します。"
        }
    }
}
```

---

## StrPost API

### リクエスト

**HTTP メソッド:** `POST`

**Content-Type:** `application/json`

**リクエストボディ:**

```json
{
  "value": "test string"
}
```

### レスポンスサンプル

```json
{
  "value": "test string"
}
```

**HTTP ステータスコード:** `200 OK`

**Content-Type:** `application/json; charset=utf-8`

### API Management 向け API 定義

#### リクエストスキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "string",
            "description": "任意。文字列を指定します。"
        }
    }
}
```

#### レスポンススキーマ定義

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "value": {
            "type": "string",
            "description": "受け取った文字列を返却します。"
        }
    }
}
```

---

## API Management ポリシー例

```xml
<policies>
  <inbound>
    <base />
    <set-backend-service base-url="https://az-di-dev-jpe-func-taktest-002-single-get-f9emgvbyc8gucqgx.japaneast-01.azurewebsites.net" />
    <rewrite-uri template="/api/{operation}" />
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

