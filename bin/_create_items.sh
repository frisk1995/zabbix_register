#!/bin/bash
## アイテムの追加

script_path="/script/zabbix-register"
. ${script_path}/env/common.env

AUTH_TOKEN=`bash ${script_path}/bin/_get_zabbix_token.sh`

## ディスカバリルールの作成
