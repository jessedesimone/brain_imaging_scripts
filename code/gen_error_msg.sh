#!/bin/bash
: 'general error message for driver script with options'

gen_error_msg="\

    Usage: ./driver.sh [-a] [-b] [-c] | [-h]
    Required arguments (at least 1 of):
    -a      <option description>
    -b      <option description>
    -c      <option description>

    Option arguments:
    -h      help

    "
    while getopts ":habc" opt; do
        case ${opt} in
                h|\?) #help option
                    echo "$gen_error_msg"
                    exit 1
                    ;;
                a) #option a
                    aflag=1
                    ;;
                b) #option b
                    bflag=1
                    ;;
                c) #option c
                    cflag=1
                    ;;
        esac
    done
    if [ $OPTIND -eq 1 ]; then
        echo "++ driver.sh requires argument"
        echo "$gen_error_msg"
        exit 1
        fi
    shift $((OPTIND -1))

#=======handle options========
if [ "$aflag" ]; then
    <do this>
fi

