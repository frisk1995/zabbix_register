#/bin/bash

## 作業用ディレクトリの作成
mkdir /tmp/ZABBIX_`date +%Y%m%d`
cd $_
pwd

## 変数の格納

## 認証トークンの取得

## アイテムの追加
### アイテムの確認
echo "hostid,itemid,name,key_,delay,history,trends,value_type,formula" > ./items.list

curl -s -d '{
    "jsonrpc": "2.0","method": "item.get",
    "params": {
        "sortfield": "name",
        "output": "extend",
        "hostids": "'${HOST_ID}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.hostid+","+.itemid+","+.name+","+.key_+","+.delay+","+.history+","+.trends+","+.value_type+","+.params' >> ./items.list

cat ./items.list | column -s, -t -o '|'

### アイテムの追加
ITEM_NAME="Resource|CPU|Util_ALL"
ITEM_KEY="cpuutil"
ITEM_TYPE="15"
ITEM_VALUE_TYPE="0"
ITEM_APPID=$(cat ./application_ids.list | grep Resource | cut -d, -f2)
ITEM_DELAY="60s"
ITEM_HISTORY="31d"
ITEM_TRENDS="31d"
ITEM_UNITS="%"
ITEM_FORMULA='last(\"system.cpu.util[,user,avg1]\")+last(\"system.cpu.util[,system,avg1]\")'

curl -s -d '{
    "jsonrpc": "2.0",
    "method": "item.create",
    "params": {
        "name": "'${ITEM_NAME}'",
        "key_": "'${ITEM_KEY}'",
        "hostid": "'${HOST_ID}'",
        "type": '${ITEM_TYPE}',
        "value_type": '${ITEM_VALUE_TYPE}',
        "interfaceid": "'${INTR_ID}'",
        "applications": [
            "'${ITEM_APPID}'"
        ],
        "delay": "'${ITEM_DELAY}'",
        "history": "'${ITEM_HISTORY}'",
        "trends": "'${ITEM_TRENDS}'",
        "units": "'${ITEM_UNITS}'",
        "params": "'${ITEM_FORMULA}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

### アイテムの確認
echo "hostid,itemid,name,key_,delay,history,trends,value_type,formula" > ./items.list

curl -s -d '{
    "jsonrpc": "2.0","method": "item.get",
    "params": {
        "sortfield": "name",
        "output": "extend",
        "hostids": "'${HOST_ID}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.hostid+","+.itemid+","+.name+","+.key_+","+.delay+","+.history+","+.trends+","+.value_type+","+.params' >> ./items.list

cat ./items.list | column -s, -t -o '|'