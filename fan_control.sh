#!/bin/bash

function set_fan_speed () {
    liquidctl --legacy-690lc set fan speed "$1"
    liquidctl --legacy-690lc set pump speed "$1"
}

CHECK_FREQ_SECONDS=3
MIN_SPEED=20
MAX_SPEED=90
MIN_TEMP=30
MAX_TEMP=70

LAST=("$MIN_SPEED" "$MIN_SPEED" "$MIN_SPEED" "$MIN_SPEED" "$MIN_SPEED")
LAST_CHANGE=$MIN_SPEED
while true;
do
    source_temp="$(sensors | grep Tctl | awk '{print $2}' | sed 's/[^0-9.]*//g')"
    current=$(printf "%.0f\n" "$source_temp")
    if [[ -z "$current" ]];
    then
        current=$MAX_TEMP
    fi
    if [[ "$current" < "$MIN_TEMP" ]]
    then
        current=$MIN_TEMP
    fi
    if [[ "$current" > "$MAX_TEMP" ]]
    then
        current=$MAX_TEMP
    fi
    speed=$((MIN_SPEED + (MAX_SPEED - MIN_SPEED) * (current - MIN_TEMP) / (MAX_TEMP - MIN_TEMP) ))

    LAST+=("$speed")
    LAST=("${LAST[@]:1}")

    for i in "${LAST[@]}";
    do
        (( i < speed )) && speed=$i
    done

    if [[ "$LAST_CHANGE" != "$speed" ]];
    then
        echo "$source_tempº [${LAST[*]}] --> $speed%"
        set_fan_speed "$speed"
    else
        echo "$source_tempº [${LAST[*]}] --> $speed% (NO CHANGE)"
    fi
    LAST_CHANGE=$speed

    sleep $CHECK_FREQ_SECONDS
done
