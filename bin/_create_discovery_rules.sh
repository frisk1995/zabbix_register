#!/bin/bash
## 登録対象ホストの所属グループID取得

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`
HOST_ID=`cat ${HOST_ID_LIST} | grep "$1" | cut -d "," -f 2`

## ディスカバリルールの作成


