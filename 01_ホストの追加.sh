#/bin/bash

## 作業用ディレクトリの作成
mkdir /tmp/ZABBIX_`date +%Y%m%d`
cd $_
pwd

## 変数の格納
### ログイン情報を変数に格納
login_user="Admin"
login_password="zabbix"
zabbix_host="localhost"

### 追加するホストの情報を変数に格納
HOSTGROUP="商用"
HOSTNAME="hogehoge"
FRONT_IP="192.168.10.1"
BACK_IP="192.168.20.1"

## 認証トークンの取得
AUTH_TOKEN=$(
    curl -s -d '{
    "jsonrpc": "2.0","method": "user.login",
    "params": {
        "user": "'${login_user}'",
        "password": "'${login_password}'"
    },"id": 1,"auth": null
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .result)

echo ${AUTH_TOKEN}

## ホストの追加
### ホストグループのID取得
HOSTGROUP_ID=$(curl -s -d '{
    "jsonrpc": "2.0","method": "hostgroup.get",
    "params": {
        "output": "extend",
        "filter": {
            "name": [
                "'${HOSTGROUP}'"
                  ]
        }
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[].groupid')

echo ${HOSTGROUP_ID}

### 追加前のホスト一覧確認
curl -s -d '{
        "jsonrpc": "2.0","method": "host.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": ["'${HOSTNAME}'"]
            }
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .result

### ホストの追加
curl -s -d '{
        "jsonrpc": "2.0","method": "host.create",
        "params": {
            "host": "'${HOSTNAME}'",
            "interfaces": [{
                    "type": "1",
                    "useip": 1,
                    "ip": "'${FRONT_IP}'",
                    "dns": "",
                    "port": "10051",
                    "main": 1
                }],
            "groups": [{
                    "groupid": "'${HOSTGROUP_ID}'"
                }]
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq . -r

### ホスト一覧のリストファイル作成
curl -s -d '{
    "jsonrpc": "2.0","method": "host.get",
    "params": {
        "output":"extend",
        "selectInterfaces":"extend"
    },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name+","+.hostid+","+.interfaces[].interfaceid'　> ./host_ids.list

cat ./host_ids.list

### ホストID取得
HOST_ID=$(cat ./host_ids.list| grep ${HOSTNAME} | awk -F',' '{ print $2 }')

echo ${HOST_ID}

### インターフェースID取得
INTR_ID=$(cat ./host_ids.list | grep ${HOSTNAME} | awk -F',' '{ print $3 }')

echo ${INTR_ID}

