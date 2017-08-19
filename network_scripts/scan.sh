#!/bin/bash

BASEDIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

sudo $BASEDIR/env/bin/python $BASEDIR/scan.py
