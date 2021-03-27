#!/bin/bash
# 1 a
grep -oE '(INFO\s.*)|(ERROR\s.*)' syslog.log

# 1 b
grep -oE 'ERROR.*' syslog.log
echo Total Error Count = $(grep -cE "ERROR" syslog.log)

# 1 d
echo "Error","Count" > error_message.csv
errMessages=$(grep -oE 'ERROR.*' syslog.log)
echo "$errMessages" | grep -oP "(?<=ERROR\s).*(?=\()" | sort | uniq |
    while read -r errMsg
    do
        number=$(grep -c "$errMsg" syslog.log)
        errMsg+=','$number
        echo "$errMsg"
    done | sort -rnk 2 -t',' >> error_message.csv

# 1 c&e
echo Username,INFO,ERROR > user_statistic.csv
usernames=$(grep -oE '(\(.*\))' syslog.log)
echo "$usernames" | tr -d ')' | tr -d '(' | sort | uniq |
    while read -r user
    do
        userError=0
        userInfo=0
        for msg in $(grep -wh "$user" syslog.log)
        do
            if [ "$msg" = "ERROR" ]
            then
                userError=$((userError+1))
            fi
            if [ "$msg" = "INFO" ]
            then
                userInfo=$((userInfo+1))
            fi
        done
        echo $user,$userError,$userInfo >> user_statistic.csv
    done
 