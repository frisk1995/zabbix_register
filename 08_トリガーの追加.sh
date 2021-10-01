#/bin/bash

## 作業用ディレクトリの作成
mkdir /tmp/ZABBIX_`date +%Y%m%d`
cd $_
pwd

## 変数の格納

## 認証トークンの取得

## トリガーの追加
### トリガーの確認
echo "triggerid,description,priority,type,expression" > ./triggers.list
curl -s -d '{
    "jsonrpc": "2.0","method": "trigger.get",
    "params": {
        "hostids": "'${HOST_ID}'",
        "output": "extend",
        "expandExpression": "0",
        "selectFunctions": "extend"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.triggerid+","+.description+","+.priority+","+.type+","+.expression' >> ./triggers.list

cat ./triggers.list | column -s, -t -o '|'

### トリガーの追加
TRIGGER_NAME="HealthCheck|AGENT Ping"
TRIGGER_EXPRESSION="{hogehoge:agent.ping.nodata(300)}=1"
TRIGGER_TYPE="0"
TRIGGER_PRIORITY="4"
TRIGGER_COMMENT=""

curl -s -d '{
  "jsonrpc": "2.0", "method": "trigger.create",
  "params": {
    "description": "HealthCheck|AGENT Ping",
    "expression": "'${TRIGGER_EXPRESSION}'",
    "priority": '${TRIGGER_PRIORITY}',
    "type": '${TRIGGER_TYPE}',
    "comments": "'${TRIGGER_COMMENT}'"
  },"auth": "'${AUTH_TOKEN}'", "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

### トリガーの確認
echo "triggerid,description,priority,type,expression" > ./triggers.list
curl -s -d '{
    "jsonrpc": "2.0","method": "trigger.get",
    "params": {
        "hostids": "'${HOST_ID}'",
        "output": "extend",
        "expandExpression": "0",
        "selectFunctions": "extend"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.triggerid+","+.description+","+.priority+","+.type+","+.expression' >> ./triggers.list

cat ./triggers.list | column -s, -t -o '|'

