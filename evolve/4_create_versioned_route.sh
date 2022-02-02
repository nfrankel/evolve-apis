#!/bin/sh
docker run --network evolve-apis_default --rm curlimages/curl:7.81.0 -v -i http://apisix:9180/apisix/admin/plugin_configs/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "plugins": {
    "proxy-rewrite": {
      "regex_uri": ["/v1(.*)", "$1"]
    }
  }
}'

docker run --network evolve-apis_default --rm curlimages/curl:7.81.0 -v -i http://apisix:9180/apisix/admin/routes/2 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "Versioned Route to Old API",
  "uri": "/v1/hello*",
  "upstream_id": 1,
  "plugin_config_id": 1
}'

