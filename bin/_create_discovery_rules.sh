#!/bin/bash
## ホストのディスカバリルールの追加

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`
HOST_ID=`cat ${HOST_ID_LIST} | grep "$1" | cut -d "," -f 2`
INTERFACE_ID=`cat ${HOST_ID_LIST} | grep "$1" | cut -d "," -f 3`

cat "${CREATE_DISCOVERY_LIST}" | egrep -v '^#|^$' > "${TMPLISTFILE_03}"

while read line;
do
    ## ディスカバリルールの作成
    result=`curl -s -d '
        {
        "jsonrpc": "2.0",
        "method": "discoveryrule.create",
        "params": {
            "name": "Mounted filesystem discovery",
            "key_": "vfs.fs.discovery",
            "hostid": "'${HOST_ID}'",
            "type": "0",
            "interfaceid": "'${INTERFACE_ID}'",
            "delay": "30s"
        },
        "auth": "'${AUTH_TOKEN}'",
        "id": 1
    }' -H "Content-Type: application/json-rpc" http://${zabbix_host}/zabbix/api_jsonrpc.php`

    echo $result
    
done < ${TMPLISTFILE_03}
