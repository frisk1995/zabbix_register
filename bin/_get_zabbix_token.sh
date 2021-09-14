#!/bin/bash
## ZABBIX認証トークンの取得

script_path="/script/zabbix-register"
. ${script_path}/env/common.env


result=`curl -s -d '{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "'${login_user}'",
        "password": "'${login_password}'"
    },
    "id": 1,
    "auth": null
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .result`

echo $result