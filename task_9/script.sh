#!/bin/bash
fmt="%s\t%s\t%s\t%s\t%s\t%s\n"

ps_ax() {
    for pid in $(ls /proc/ | egrep "^[0-9]" | sort -n); do
    if [[ -f /proc/$pid/status ]]; then
        PID=$pid
        tty_number=`awk '{print $7}' /proc/$pid/stat`
        
        TTY="?"
        if [[ $tty_number -ne 0 ]]; then
            TTY=$(ls -la /proc/$pid/fd/ | grep -E 'pts|tty' | cut -d\/ -f3,4 | uniq )
            if [ -z $TTY ]; then
                TTY="?"
            fi
        fi

        STAT=$(awk '/State/ {print $2}' /proc/$pid/status)
        
        NICE=$(awk '{print $19}' /proc/$pid/stat )

        if [[ $NICE -gt 0 ]]; then
            STAT+="N"
        elif [[ $NICE -lt 0 ]]; then
            STAT+="<"
        fi

        LOCK=$(cat /proc/$pid/status | awk '/VmLck/{print $2}')
        if [[ $LOCK -gt 0 ]]; then
            STAT+="L"
        fi

        PID=$(awk '{print $1}' /proc/$pid/stat)
        SID=$(awk '{print $6}' /proc/$pid/stat)
        if [ $PID -eq $SID ]; then
            STAT+="s"
        fi


        THREAD=$(awk '{print $20}' /proc/$pid/stat)
        if [ $THREAD -gt 1 ]; then
            STAT+="l"

        fi

        FG=$(awk '{print $8}' /proc/$pid/stat)
        if [ $FG -ne -1 ]; then
            STAT+="+"
        fi

        SEC=$((`awk '{print $14+$15}' /proc/$pid/stat` / 100))
        TIME_MIN=$(($SEC / 60))
        TIME_SEC=$(($SEC % 60))
        TIME="$TIME_MIN:$TIME_SEC"

        COMM=$(cat /proc/$pid/cmdline | sed 's/\x0/ /g')
        if [ -z "$COMM" ]; then
            COMM=$(awk '/Name/{ print $2 }' /proc/$pid/status)
            COMM="[$COMM]"
        fi
        printf $fmt $PID $TTY $STAT $TIME $COMM
    fi
    done
}

printf "$fmt" PID TTY STAT TIME COMMANDS

ps_ax