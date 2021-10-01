#/bin/bash

## 作業用ディレクトリの作成
mkdir /tmp/ZABBIX_`date +%Y%m%d`
cd $_
pwd

## 変数の格納

## 認証トークンの取得

## ディスカバリルールの追加
### ディスカバリルールの一覧確認
curl -s -d '{
    "jsonrpc": "2.0","method": "discoveryrule.get",
    "params": {
        "output": "extend",
        "hostids": "'${HOST_ID}'"
    },"auth": "'${AUTH_TOKEN}'", "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name+","+.key_+","+.delay+","+.type+","+.itemid'

### ディスカバリルールの追加
#### Zabbix_Interfaceの追加
curl -s -d '{
    "jsonrpc": "2.0","method": "discoveryrule.create",
    "params": {
        "name": "Zabbix_Interface",
        "key_": "net.if.discovery",
        "hostid": "'${HOST_ID}'",
        "type": "0",
        "interfaceid": "'${INTR_ID}'",
        "delay": "300s",
        "status": "0",
        "filter": {
            "evaltype": 1,
            "conditions": [
                {
                    "macro": "{#IFNAME}",
                    "value": "@LLD_Interface_01"
                }
            ]
        }
    },"auth": "'${AUTH_TOKEN}'", "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

### ディスカバリルールの追加
curl -s -d '{
    "jsonrpc": "2.0","method": "discoveryrule.get",
    "params": {
        "output": "extend",
        "hostids": "'${HOST_ID}'"
    },"auth": "'${AUTH_TOKEN}'", "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name+","+.key_+","+.delay+","+.type+","+.itemid' > ./discovery_ids.list

cat ./discovery_ids.list

### ディスカバリアイテムIDの確認
DISCOVERY_ITEMID=$(curl -s -d '{
    "jsonrpc": "2.0","method": "discoveryrule.get",
    "params": {
        "output": "extend",
        "hostids": "'${HOST_ID}'"
    },"auth": "'${AUTH_TOKEN}'", "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.itemid')
 
echo ${DISCOVERY_ITEMID}

### ディスカバリフィルタの確認
curl -s -d '{
    "jsonrpc": "2.0","method": "discoveryrule.get",
    "params": {
  "output": ["name"],
        "selectFilter": "extend",
        "itemids": ["'${DISCOVERY_ITEMID}'"]
    },"auth": "'${AUTH_TOKEN}'", "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name+","+.filter.conditions[].macro+","+.filter.conditions[].value'

