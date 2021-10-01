#/bin/bash

## 作業用ディレクトリの作成
mkdir /tmp/ZABBIX_`date +%Y%m%d`
cd $_
pwd

## 変数の格納

## 認証トークンの取得


## アプリケーションの追加
### アプリケーションの確認
curl -s -d '{"jsonrpc": "2.0","method": "application.get",
        "params": {
            "output": "extend",
            "hostids": "'${HOST_ID}'",
            "sortfield": "name"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name'

### アプリケーションの追加
#### AuditLog_LogFile
curl -s -d '{"jsonrpc": "2.0","method": "application.create",
        "params": {
            "name": "AuditLog_LogFile",
            "hostid": "'${HOST_ID}'"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### HealthCheck
curl -s -d '{"jsonrpc": "2.0","method": "application.create",
        "params": {
            "name": "HealthCheck",
            "hostid": "'${HOST_ID}'"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### LogFile
curl -s -d '{"jsonrpc": "2.0","method": "application.create",
        "params": {
            "name": "LogFile",
            "hostid": "'${HOST_ID}'"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### Ping
curl -s -d '{"jsonrpc": "2.0","method": "application.create",
        "params": {
            "name": "Ping",
            "hostid": "'${HOST_ID}'"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### Process
curl -s -d '{"jsonrpc": "2.0","method": "application.create",
        "params": {
            "name": "Process",
            "hostid": "'${HOST_ID}'"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

#### Resource
curl -s -d '{"jsonrpc": "2.0","method": "application.create",
        "params": {
            "name": "Resource",
            "hostid": "'${HOST_ID}'"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r .

### アプリケーションの確認
curl -s -d '{"jsonrpc": "2.0","method": "application.get",
        "params": {
            "output": "extend",
            "hostids": "'${HOST_ID}'",
            "sortfield": "name"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name'

### アプリケーションIDリストの作成
curl -s -d '{"jsonrpc": "2.0","method": "application.get",
        "params": {
            "output": "extend",
            "hostids": "'${HOST_ID}'",
            "sortfield": "name"
        },"auth": "'${AUTH_TOKEN}'","id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.name+","+.applicationid' > ./application_ids.list

cat ./application_ids.list
