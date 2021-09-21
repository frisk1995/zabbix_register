#!/bin/bash
## アプリケーションの作成

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`
HOST_ID=`cat ${HOST_ID_LIST} | grep "$1" | cut -d "," -f 2`

## アプリケーションの追加
echo "[" $1 "] アプリケーションの追加を実行します。"
cat "${CREATE_APP_LIST}" | egrep -v '^#|^$' > "${TMPLISTFILE_02}"
while read line;
do
    result=`curl -s -d '
    {
        "jsonrpc": "2.0",
        "method": "application.create",
        "params": {
            "name": "'$line'",
            "hostid": "'${HOST_ID}'"
        },
        "auth": "'${AUTH_TOKEN}'",
        "id": 1
    }
    ' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php`
    #echo $result | jq -r
    if [ "`echo $result | jq -r .error.data | grep "already exists"`" ];then
        ## すでに登録されている場合
        echo "[" $1 "] アプリケーション[" $line "]はすでに登録されています。"
    else
        ## 登録に成功した場合
        echo "[" $1 "] アプリケーション[" $line "]を登録しました。"
    fi
    
done < ${TMPLISTFILE_02}
