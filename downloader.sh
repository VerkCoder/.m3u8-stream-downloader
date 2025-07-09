#!/bin/bash

downloader() {
    link=$1
    output_file=$2

    command="ffmpeg -i \"$link\" -bsf:a aac_adtstoasc -vcodec copy -c copy \"$(dirname "$(realpath "$0")")/$output_file\""
    echo "$command"

    read -p "Turn the computer off after downloading?.. (y/n) " turn_off
    turn_off_flag=$( [ "$turn_off" = "y" ] && echo "true" || echo "false" )

    read -p "Start downloading?.. (y/n) " start_download
    if [ "$start_download" = "y" ]; then
        time_start=$(date +%s)
        eval "$command"

        timer=$(( $(date +%s) - time_start ))
        hours=$(( timer / 3600 ))
        minutes=$(( (timer / 60) % 60 ))
        seconds=$(( timer % 60 ))

        echo -n "Script running time:"
        [ $hours -gt 0 ] && echo -n " ${hours}h"
        [ $minutes -gt 0 ] || [ $hours -gt 0 ] && echo -n " ${minutes}m"
        echo " ${seconds}s"

        if [ "$turn_off_flag" = "true" ]; then
            shutdown -h now
        fi
    else
        echo "Aborted."
    fi
}

main() {
    read -p "Enter .m3u8 link.. " link_
    read -p "Enter output file name.. " outputfile_

    if [ -n "$outputfile_" ] && [ -n "$link_" ]; then
        if [[ "$outputfile_" == *.mp4 ]]; then
            if [[ "$link_" == *.m3u8 ]] && [[ "$link_" == http* ]]; then
                downloader "$link_" "$outputfile_"
            else
                echo 'Incorrect link format(not .m3u8)'
            fi
        else
            echo "Incorrect output file format(not .mp4)"
        fi
    else
        echo "Parameters cannot be empty"
    fi
}

main