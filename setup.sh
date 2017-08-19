#!/bin/bash

BASEDIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

install_scan() {
    cd $BASEDIR/scan_network
    virtualenv env
    source env/bin/activate
    pip install -r requirements.txt
    deactivate
    sudo apt-get install nmap
    cd ..
}

install_bettercap() {
    sudo apt-get install build-essential ruby-dev libpcap-dev
    sudo gem install bettercap
}

install_scan
install_bettercap
