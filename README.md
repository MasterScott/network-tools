Network Tools
=============

Hacking tools for everyday use.

This repository mainly contains scripts that automate the installation and
deployment of penetration testing tools that implement network attacks such as
spoofing, sniffing etc.

## Tools

### scan

Shell script to scan a network for active nodes.

Usage:
```sh
./scan
```

### mitm

Shell script to Man-in-the-Middle and sniff a network.

Usage:
```sh
./mitm <parameter>

where <parameter> is:
    <empty> Man-in-the-Middle and sniff the entire network.
    --strip Enable sslstrip.
    --scan Scan local network and display the results.
    --injectjs <filepath> Inject the JS code in the given file.
    --injectcss <filepath> Inject the CSS code in the given file.
```

## Installation

You will need to install several dependencies to use the tools in this
repository. Choose and install the dependencies you want by running:

```sh
./setup.sh
```

## Disclaimer

The tools in this repository are intented for penetration testing. Do not use
any of the code for immoral or illegal purposes that may harm people or systems.

## License
All code is licensed under MIT. See LICENSE for more information.
