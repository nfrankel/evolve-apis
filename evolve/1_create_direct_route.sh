#!/bin/sh
curl http://localhost:9180/apisix/admin/routes/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "Direct Route to Old API",
  "uri": "/hello*",
  "upstream": {
    "nodes": {
      "oldapi:8081": 1
    }
  },
  "plugins": {
    "prometheus": {}
  }
}'
