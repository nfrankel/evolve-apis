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
    "unauth-limit": {
      "count": 1,
      "time_window": 60,
      "key_type": "var",
      "key": "consumer_name",
      "rejected_code": 429,
      "rejected_msg": "Please register at https://apisix.org/register to get your API token and enjoy unlimited calls"
    }
  }
}'
