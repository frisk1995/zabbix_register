#!/bin/bash
## ホスト追加スクリプト

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

# ZABBIX認証トークンの取得
AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`

# リストファイルからパラメータ取得
cat "${CREATE_HOST_LIST}" | egrep -v '^#|^$' > "${TMPLISTFILE_01}"
while read line;
do
    _HOSTGROUP=`echo $line | cut -d"," -f 1`
    _HOSTNAME=`echo $line | cut -d"," -f 2`
    _TYPE=`echo $line | cut -d"," -f 3`
    _IPADD=`echo $line | cut -d"," -f 4`
    _PORT=`echo $line | cut -d"," -f 5`
    
    # ホスト追加
    ## 追加対象ホストが存在しないか確認
    ### ホストID取得
    TARGET_HOST_ID=`curl -s -d '
    {
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": "extend",
            "filter": {
                "name": [
                    "'${_HOSTNAME}'"
                    ]
            }
        },
        "auth": "'${AUTH_TOKEN}'",
        "id": 1
    }
    ' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq -r '.result[]|.TARGET_HOST_ID'`
    
    if [ "${TARGET_HOST_ID}" = "" ]; then
        ## 追加対象ホストが存在しないとき
        echo "========================================================"
        echo "ホスト[" ${_HOSTNAME} "]を追加します。"
        
        ## ホストグループID取得
        _HOSTGROUP_ID=`bash ${script_path}/bin/_get_hostgroup_id.sh ${_HOSTGROUP}`
        
        ## ホスト追加
        _HOST_ID=`curl -s -d '
        {
            "jsonrpc": "2.0",
            "method": "host.create",
            "params": {
                "host": "'${_HOSTNAME}'",
                "interfaces": [
                    {
                        "type": "'${_TYPE}'",
                        "useip": 1,
                        "ip": "'${_IPADD}'",
                        "dns": "",
                        "port": "'${_PORT}'",
                        "main": 1
                    }
                ],
                "groups": [
                    {
                        "groupid": "'${_HOSTGROUP_ID}'"
                    }
                ]
            },
            "auth": "'${AUTH_TOKEN}'",
            "id": 1
        }
        ' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php | jq .result.hostids[]`
        ## ホスト追加に成功したら
        if [ "${_HOST_ID}" = "" ]; then
            echo "[" $_HOSTNAME "]ホストの追加に失敗しました。"
        else
            echo "ホスト[" ${_HOSTNAME} "]の追加に成功しました。"
        fi
    else
        ## 追加対象ホストがすでに存在するとき
        echo "========================================================"
        echo "追加対象ホスト[" ${_HOSTNAME} "]がすでに存在します。"
    fi

    ## ホストID取得
    bash ${script_path}/bin/_get_host_ids.sh
    
    ## アプリケーションの追加
    bash ${script_path}/bin/_create_applications.sh ${_HOSTNAME}
    
    ## ディスカバリの追加
    bash ${script_path}/bin/_create_discovery_rules.sh ${_HOSTNAME}


done < ${TMPLISTFILE_01}
