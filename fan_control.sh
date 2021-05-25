#!/bin/bash

function set_fan_speed () {
    let temp=$(printf "%.0f\n" $1)
    liquidctl --legacy-690lc set fan speed $1
    liquidctl --legacy-690lc set pump speed $1
}

CHECK_FREQ_SECONDS=3
MIN_SPEED=30
MAX_SPEED=100
MIN_TEMP=25
MAX_TEMP=65

while [[ true ]];
do
    source_temp="$(sensors | grep Tctl | awk '{print $2}' | sed 's/[^0-9.]*//g')"
    current=$(printf "%.0f\n" $source_temp)
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
    echo $source_temp"º -->" $speed"%"
    set_fan_speed $speed
    sleep $CHECK_FREQ_SECONDS
done
