#!/bin/bash -e
#
# setup.sh
# Copyright (C) 2016 Dimitris Karakostas <dimit.karakostas@gmail.com>
#
# Distributed under terms of the MIT license.
#

BASEDIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

scanning() {
    cd $BASEDIR/network_scripts
    virtualenv env
    source env/bin/activate
    pip install -r requirements.txt
    deactivate
    cd ..
    sudo apt-get install nmap
}

bettercap() {
    sudo apt-get install build-essential ruby-dev libpcap-dev
    sudo gem install bettercap
}

sslstrip() {
    cd $BASEDIR/network_scripts
    wget https://moxie.org/software/sslstrip/sslstrip-0.9.tar.gz
    tar zxvf sslstrip-0.9.tar.gz
    rm sslstrip-0.9.tar.gz
    cd ..
    sudo apt-get install python python-twisted-web
}

echo "[*] Select tools to install: "
select INSTALL in "Bettercap & sslstrip & nmap" "Bettercap" "sslstrip" "nmap"
do
    case $INSTALL in
        "Bettercap & sslstrip & nmap")
            sslstrip
            bettercap
            scanning
            break
            ;;
        "Bettercap")
            bettercap
            break
            ;;
        "sslstrip")
            sslstrip
            break
            ;;
        "nmap")
            scanning
            break
            ;;
        *)
            echo "[!] Terminating installation."
            break
    esac
done
