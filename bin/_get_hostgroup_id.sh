#!/bin/bash
## 登録対象ホストの所属グループID取得

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`

## ホストグループIDを取得
curl -s -d '
{
    "jsonrpc": "2.0",
    "method": "hostgroup.get",
    "params": {
        "output": "extend",
        "filter": {
            "name": [
                "'$1'"
                  ]
        }
    },
    "auth": "'${AUTH_TOKEN}'",
    "id": 1
}
' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[].groupid'

echo $result
