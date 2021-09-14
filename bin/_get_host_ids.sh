#!/bin/bash
## ホストID取得

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`

HOSTNAME=$1

curl -s -d '{
    "auth": "'${AUTH_TOKEN}'",
    "method": "host.get",
    "id": 1,
    "params": {
        "output":"extend",
        "selectInterfaces":"extend"
    },
    "jsonrpc": "2.0"
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name+","+.hostid+","+.interfaces[].interfaceid' > ${HOST_ID_LIST}
