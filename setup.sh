#!/bin/bash -e

BASEDIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

scanning() {
    cd $BASEDIR/network_scripts
    virtualenv env
    source env/bin/activate
    pip install -r requirements.txt
    deactivate
    sudo apt-get install nmap
    cd ..
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

echo "[*] Tools to install: "
select INSTALL in "Bettercap & sslstrip & scanning (nmap, python)" "Bettercap" "sslstrip" "scanning (nmap, python)"
do
    case $INSTALL in
        "Bettercap & sslstrip & scanning (nmap, python)")
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
        "scanning (nmap, python)")
            scanning
            break
            ;;
        *)
            echo "[!] Terminating installation."
            break
    esac
done
