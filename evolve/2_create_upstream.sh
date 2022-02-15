#!/bin/sh
docker run --network evolve-apis_default --rm curlimages/curl:7.81.0 -v -i http://apisix:9180/apisix/admin/upstreams/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "Old API",
  "nodes": {
    "oldapi:8081": 1
  }
}'
