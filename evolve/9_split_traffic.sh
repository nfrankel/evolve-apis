#!/bin/sh
docker run --network evolve-apis_default --rm curlimages/curl:7.81.0 -v -i http://apisix:9080/apisix/admin/upstreams/2 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "New API",
  "type": "roundrobin",
  "nodes": {
    "newapi:8082": 1
  }
}'

docker run --network evolve-apis_default --rm curlimages/curl:7.81.0 -v -i http://apisix:9080/apisix/admin/plugin_configs/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PATCH -d '
{
 "plugins": {
    "proxy-rewrite": {
      "regex_uri": ["/v1/(.*)", "/$1"]
    },
    "unauth-limit": {
      "count": 1,
      "time_window": 60,
      "key_type": "var",
      "key": "consumer_name",
      "rejected_code": 429,
      "rejected_msg": "Please register at https://apisix.org/register to get your API token and enjoy unlimited calls"
    },
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

