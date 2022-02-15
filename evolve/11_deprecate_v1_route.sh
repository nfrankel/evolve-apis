#!/bin/sh
curl http://localhost:9180/apisix/admin/plugin_configs/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PATCH -d '
{
 "plugins": {
    "traffic-split": null,
    "response-rewrite": {
      "headers": {
        "Deprecation": "true",
        "Link": "<$scheme://$host:$server_port/v2/hello; rel=\"successor-version\">"
      }
    }
  }
}'