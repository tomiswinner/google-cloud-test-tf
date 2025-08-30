#!/bin/bash

ACCESS_TOKEN="$(gcloud auth print-access-token)"
curl -sS -X PATCH \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  "https://compute.googleapis.com/compute/v1/projects/$1/global/backendServices/$2" \
  -d '{
    "securitySettings": {
      "awsV4Authentication": {
        "accessKeyId": "'$3'",
        "accessKey": "'$4'",
        "originRegion": "'$5'"
      }
    }
  }'
