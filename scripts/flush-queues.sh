#!/usr/bin/env bash

user=$1
password=$2
url=$3
bindings=$4


jq '.bindings' ${bindings} | jq -c '.[]' | while read i; do
    queue=`echo ${i} | jq '.queue' | tr -d '"'`

    if [[ "${queue}" = "null" ]]
    then
        continue
    fi

    curl -X DELETE -u ${user}:${password} http://${url}/api/queues/%2F/${queue}/contents
    curl -X DELETE -u ${user}:${password} http://${url}/api/queues/%2F/${queue}-deadletter/contents

done
