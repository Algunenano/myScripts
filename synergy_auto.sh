#!/bin/bash
PING_FREC=30
CONN_FREC=600
WIFI_ID="xxxx"
SERVER_IP="xxxx"
LAUNCHED="0"
COMMAND="synergyc"

function wifi_connected {
    local wifi=`netctl-auto list 2>&1 | grep $WIFI_ID`
    local conn=${wifi:0:1}
    if [[ "$conn" == "*" ]]; then echo 1; else echo 0; fi
}

function ping_server {
    `ping $SERVER_IP -c 1 2>&1 >/dev/null`
    if [[ "$?" == "0" ]]; then echo 1; else echo 0; fi
}

function synergy_start {
    $COMMAND -f -1 -d NOTE $SERVER_IP 2>&1 >/dev/null
}

while [[ true ]];
do
#     if [[ `wifi_connected` == "0" ]]; then
#         sleep $CONN_FREC
#     else
        if [[ `ping_server` == "1" ]]; then
        #Connected and server is up
            synergy_start
        fi
        sleep $PING_FREC
#     fi
done
