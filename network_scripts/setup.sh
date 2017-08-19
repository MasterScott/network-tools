#!/bin/bash
#
# setup.sh
# Copyright (C) 2016 Dimitris Karakostas <dimit.karakostas@gmail.com>
#
# Distributed under terms of the MIT license.
#

bettercap() {
    sudo apt-get install ruby rubygems build-essential ruby-dev libpcap-dev
    sudo gem install syslog-logger bettercap
}

bettercap_kali() {
    apt-get install bettercap
}

sslstrip() {
    sudo apt-get install python python-twisted-web
    wget https://moxie.org/software/sslstrip/sslstrip-0.9.tar.gz
    tar zxvf sslstrip-0.9.tar.gz
    rm sslstrip-0.9.tar.gz
    cd sslstrip-0.9 && sudo python ./setup.py install
}

BASEDIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

echo "[*] Select tools to install: "
select INSTALL in "Bettercap, sslstrip (Debian)" "Bettercap, sslstrip (Kali)" "Bettercap (Debian)" "Bettercap (Kali)" "sslstrip"
do
    case $INSTALL in
        "Bettercap, sslstrip (Debian)")
            bettercap
            sslstrip
            break
            ;;
        "Bettercap, sslstrip (Kali)")
            bettercap_kali
            sslstrip
            break
            ;;
        "Bettercap (Debian)")
            bettercap
            break
            ;;
        "Bettercap (Kali)")
            bettercap_kali
            break
            ;;
        "sslstrip")
            sslstrip
            break
            ;;
        *)
            echo "[!] Terminating installation."
            break
    esac
done
