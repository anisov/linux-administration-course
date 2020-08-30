#!/bin/bash

# Variabels.
LOGS=$(dirname $(realpath $0))/../logs/access.log
TMP_LOGS=/tmp/_access.log
META_INFO="/var/log/access_meta_info.log"

# Datetime.
last_datetime="First run"
current_datetime=$(date +"%b %d %H:%M:%S")

# Get state from logs(meta info).
if [[ -e "$META_INFO" ]]; then
    # Get the last processed datetime.
    last_datetime=$(sed -rn 's/last_run_datetime: (.*)/\1/p' "$META_INFO")
    # Get the last processed line.
    last_line=$(sed -rn 's/last_line: ([0-9]+)/\1/p' "$META_INFO")
fi

# Create file from last processed line.
if [[ $last_line ]]; then
    ((last_line++))
    sed -e "1,${last_line}d" $LOGS > $TMP_LOGS
else
    cp $LOGS $TMP_LOGS
fi

# Helpers

get_count(){
    sort | uniq -c
}

sorting(){
    sort -rn
}

get_top(){
    head -n 5
}

wrapper(){
    echo "************"
    echo ""
    "$@"
    echo ""

}

# Main

top_ips(){
    echo "Top 5 ip's."
    cat $TMP_LOGS | awk '{print $1}' | get_count | sorting | get_top
}

top_pages(){
    echo "Top 5 address."
    cat $TMP_LOGS | awk '{print $7}' | get_count | sorting | get_top
}

top_errors_code(){
    echo "Top 5 errors status code."
    cat $TMP_LOGS | awk '{print $9}' | grep -E "4[0-9][0-9]|5[0-9][0-9]" | get_count | sorting | get_top
}

top_code(){
    echo "Top 5 code status."
    cat $TMP_LOGS | awk '{print $9}'| grep -E "1[0-9][0-9]|2[0-9][0-9]|3[0-9][0-9]|4[0-9][0-9]|5[0-9][0-9]" | get_count | sorting | get_top
}


echo "Get logs: from $last_datetime to $current_datetime."

wrapper top_ips
wrapper top_pages
wrapper top_code
wrapper top_errors_code

# Save state in logs(meta info).
cat << EOF > $META_INFO
last_run_datetime: $current_datetime
last_line: $(wc -l $LOGS | awk '{print $1}')
EOF