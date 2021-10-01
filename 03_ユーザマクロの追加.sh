#/bin/bash

## 作業用ディレクトリの作成
mkdir /tmp/ZABBIX_`date +%Y%m%d`
cd $_
pwd

## 変数の格納

## 認証トークンの取得

## ユーザマクロの追加
### ユーザマクロの確認
curl -s -d '{
   "jsonrpc": "2.0","method": "usermacro.get",
    "params": {
        "output": "extend",
        "hostids": "'${HOST_ID}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[] | .macro+","+.value'

### ユーザマクロの追加
#### $IP1の追加
curl -s -d '{
    "jsonrpc": "2.0","method": "usermacro.create",
    "params": {
        "hostid": "'${HOST_ID}'",
        "macro": "{$IP1}",
        "value": "'${FRONT_IP}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### $IP2の追加
curl -s -d '{
    "jsonrpc": "2.0","method": "usermacro.create",
    "params": {
        "hostid": "'${HOST_ID}'",
        "macro": "{$IP2}",
        "value": "'${BACK_IP}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

### ユーザマクロの確認
curl -s -d '{
   "jsonrpc": "2.0","method": "usermacro.get",
    "params": {
        "output": "extend",
        "hostids": "'${HOST_ID}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[] | .macro+","+.value'
