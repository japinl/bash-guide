#!/bin/bash
#
# This script prints the number of days in this month, and give information
# about leap years if the current month is February.

year=$(date +%Y)
month=$(date +%m)

case "$month" in
    "01" | "03" | "05" | "07" | "08" | "10" | "12")
        echo "This month has 31 days"
        ;;
    "04" | "06" | "09" | "11")
        echo "This month has 30 days"
        ;;
    "02")
        if (( "$year" % 400 == "0")) || (( ("$year" % 4 == "0") && ("$year" % 100 != "0") )); then
            echo "This year is a leap year, and this month has 29 days"
        else
            echo "This year is not a leap year, and this month has 28 days"
        fi
        ;;
    *)
        echo "Error"
        exit 1
        ;;
esac
exit 0
