#!/bin/sh
curl http://localhost:9180/apisix/admin/upstreams/2 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "New API",
  "type": "roundrobin",
  "nodes": {
    "newapi:8082": 1
  }
}'

curl http://localhost:9180/apisix/admin/plugin_configs/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PATCH -d '
{
 "plugins": {
    "proxy-mirror": null,
    "traffic-split": {
      "rules": [
        {
          "weighted_upstreams": [
            {
              "upstream_id": 2,
              "weight": 1
            },
            {
              "weight": 1
            }
          ]
        }
      ]
    }
  }
}'

