#!/bin/sh
curl http://localhost:9180/apisix/admin/routes/4 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "Versioned Route to New API",
  "uri": "/v2/hello*",
  "upstream_id": 2,
  "plugins": {
    "proxy-rewrite": {
      "regex_uri": ["/v2(.*)", "$1"]
    },
    "key-auth": {}
  }
}'
