#!/bin/sh

curl http://localhost:9180/apisix/admin/routes/2 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PATCH -d '
{
  "name": "Authenticated Route to v1",
  "priority": 10,
  "plugins": {
    "key-auth": {}
  },
  "vars": [[ "http_apikey", "~~", ".*" ]]
}'

curl http://localhost:9180/apisix/admin/routes/3 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "Free Tier Route to v1",
  "uri": "/v1/hello*",
  "upstream_id": 1,
  "plugin_config_id": 1,
  "plugins": {
    "limit-count": {
      "count": 1,
      "time_window": 60,
      "key_type": "var",
      "key": "consumer_name",
      "rejected_code": 429,
      "rejected_msg": "Please register at https://apisix.org/register to get your API token and enjoy unlimited calls"
    }
  }
}'
