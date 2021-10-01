#/bin/bash

## 作業用ディレクトリの作成
mkdir /tmp/ZABBIX_`date +%Y%m%d`
cd $_
pwd

## 変数の格納
## 認証トークンの取得

## プロトタイプの追加 ====================================================

### アイテムのプロトタイプの確認
curl -s -d '{
    "jsonrpc": "2.0", "method": "itemprototype.get",
    "params": {
        "output": "extend",
        "discoveryids": "'${DISCOVERY_ITEMID}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

### アプリケーションID(Resource)の取得
APP_ID=$(cat ./application_ids.list | grep Resource | cut -d',' -f 2)
echo ${APP_ID}

### アイテムのプロトタイプの作成
#### ifInErrors
curl -s -d '{
    "jsonrpc": "2.0",
    "method": "itemprototype.create",
    "params": {
        "name": "Resource|Interface|ifInErrors_{#IFNAME}",
        "key_": "net.if.in[{#IFNAME},errors]",
        "hostid": "'${HOST_ID}'",
        "ruleid": "'${DISCOVERY_ITEMID}'",
        "type": 0,
        "value_type": 3,
        "interfaceid": "'${INTR_ID}'",
        "delay": "300s",
        "history": "396d",
        "trends": "396d",
        "applications": {
            "applicationid": "'${APP_ID}'"
        },
        "preprocessing": [
            {
                "type": "9",
                "params": ""
            }
        ]
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### ifInOctets
curl -s -d '{
    "jsonrpc": "2.0",
    "method": "itemprototype.create",
    "params": {
        "name": "Resource|Interface|ifInOctets_{#IFNAME}",
        "key_": "net.if.in[{#IFNAME},bytes]",
        "hostid": "'${HOST_ID}'",
        "ruleid": "'${DISCOVERY_ITEMID}'",
        "type": 0,
        "value_type": 3,
        "interfaceid": "'${INTR_ID}'",
        "delay": "300s",
        "history": "396d",
        "trends": "396d",
        "applications": {
            "applicationid": "'${APP_ID}'"
        },
        "preprocessing": [
            {
                "type": "9",
                "params": ""
            }
        ]
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### ifOutErrors
curl -s -d '{
    "jsonrpc": "2.0",
    "method": "itemprototype.create",
    "params": {
        "name": "Resource|Interface|ifOutErrors_{#IFNAME}",
        "key_": "net.if.out[{#IFNAME},errors]",
        "hostid": "'${HOST_ID}'",
        "ruleid": "'${DISCOVERY_ITEMID}'",
        "type": 0,
        "value_type": 3,
        "interfaceid": "'${INTR_ID}'",
        "delay": "300s",
        "history": "396d",
        "trends": "396d",
        "applications": {
            "applicationid": "'${APP_ID}'"
        },
        "preprocessing": [
            {
                "type": "9",
                "params": ""
            }
        ]
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### ifOutOctets
curl -s -d '{
    "jsonrpc": "2.0",
    "method": "itemprototype.create",
    "params": {
        "name": "Resource|Interface|ifOutOctets_{#IFNAME}",
        "key_": "net.if.out[{#IFNAME},bytes]",
        "hostid": "'${HOST_ID}'",
        "ruleid": "'${DISCOVERY_ITEMID}'",
        "type": 0,
        "value_type": 3,
        "interfaceid": "'${INTR_ID}'",
        "delay": "300s",
        "history": "396d",
        "trends": "396d",
        "applications": {
            "applicationid": "'${APP_ID}'"
        },
        "preprocessing": [
            {
                "type": "9",
                "params": ""
            }
        ]
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

### アイテムのプロトタイプの確認
curl -s -d '{
    "jsonrpc": "2.0", "method": "itemprototype.get",
        "params": {
        "output": "extend",
        "discoveryids": "'${DISCOVERY_ITEMID}'"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.hostid+", "+.name+", "+.key_+", "+.delay+", "+.history+", "+.trends'
