#!/bin/bash
## ユーザマクロの作成

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`
HOST_ID=`cat ${HOST_ID_LIST} | grep "$1" | cut -d "," -f 2`
front_ip=`cat ${CREATE_HOST_LIST} | grep "$1" | cut -d "," -f 4`
back_ip=`cat ${CREATE_HOST_LIST} | grep "$1" | cut -d "," -f 5`

## ユーザマクロの作成

result=`curl -s -d '
{
    "jsonrpc": "2.0",
    "method": "usermacro.create",
    "params": {
        "hostid": "'${HOST_ID}'",
        "macro": "{$IP1}",
        "value": "'${front_ip}'"
    },
    "auth": "'${AUTH_TOKEN}'",
    "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php`

if [ "`echo $result | jq -r .error.data | grep "already exists"`" ];then
    ## すでに登録されている場合
    echo "[" $1 "] アプリケーション[ マクロ IP1 ]はすでに登録されています。"
else
    ## 登録に成功した場合
    echo "[" $1 "] アプリケーション[ マクロ IP1 ]を登録しました。"
fi

result=`curl -s -d '
{
    "jsonrpc": "2.0",
    "method": "usermacro.create",
    "params": {
        "hostid": "'${HOST_ID}'",
        "macro": "{$IP2}",
        "value": "'${back_ip}'"
    },
    "auth": "'${AUTH_TOKEN}'",
    "id": 1
}' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php`

if [ "`echo $result | jq -r .error.data | grep "already exists"`" ];then
    ## すでに登録されている場合
    echo "[" $1 "] アプリケーション[ マクロ IP2 ]はすでに登録されています。"
else
    ## 登録に成功した場合
    echo "[" $1 "] アプリケーション[ マクロ IP2 ]を登録しました。"
fi
