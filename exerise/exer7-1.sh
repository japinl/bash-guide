#!/bin/bash
#
# This script prints the number of days in this month, and give information
# about leap years if the current month is February.

year=$(date +%Y)
month=$(date +%m)

if [ $month -eq "01" -o $month -eq "03" -o $month -eq "05" -o $month -eq "07" -o $month -eq "08" -o $month -eq "10" -o $month -eq "12" ]; then
    echo "This month has 31 days"
elif [ $month -eq "02" ]; then
    if (( "$year" % 400 == "0")) || (( ("$year" % 4 == "0") && ("$year" % 100 != "0") )); then
        echo "This year is a leap year, and this month has 29 days"
    else
        echo "This year is not a leap year, and this month has 28 days"
    fi
else
    echo "This month has 30 days"
fi
exit 0
