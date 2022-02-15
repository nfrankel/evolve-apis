#!/bin/sh
curl http://localhost:9180/apisix/admin/plugin_configs/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PATCH -d '
{
 "plugins": {
    "proxy-rewrite": {
      "_meta": {
        "priority": 1020
      }
    },
    "proxy-mirror": {
      "host": "http://new.api:8082"
    }
  }
}'
