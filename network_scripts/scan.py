import subprocess
import os
from bs4 import BeautifulSoup
import netifaces
from netaddr import IPAddress


def add_spaces(total_length, covered):
    return ' ' * (total_length - len(covered))


interface = netifaces.gateways()[netifaces.AF_INET][0][1]
network_address = netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['addr']
netmask = netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['netmask']
network = network_address + '/' + str(IPAddress(netmask).netmask_bits())
print '[*] Scanning network...'
print '[*] interface: {}, network: {}'.format(interface, network)
proc = subprocess.Popen(['sudo', 'nmap', '-oX', '-', '-sn', '-PS21,22,25,3389', network], stdout=subprocess.PIPE, preexec_fn=os.setpgrp)

nmap_output = proc.communicate()[0]

print 'Hostname{}|IPv4{}|MAC{}|Vendor'.format(
    add_spaces(30, 'Hostname'),
    add_spaces(18, 'IPv4'),
    add_spaces(20, 'MAC')
)
print 85 * '-'

other_list = []
soup = BeautifulSoup(nmap_output, 'html.parser')
for host in soup.findAll('host'):
    host_attrs = {}
    host_attrs['mac'] = ''
    host_attrs['vendor'] = ''

    address_list = host.findAll('address')
    for address in address_list:
        addr_attrs = dict(address.attrs)
        if addr_attrs[u'addrtype'] == 'ipv4':
            host_attrs['ipv4'] = addr_attrs[u'addr']
        elif addr_attrs[u'addrtype'] == 'mac':
            host_attrs['mac'] = addr_attrs[u'addr']
            host_attrs['vendor'] = addr_attrs[u'vendor'] if 'vendor' in addr_attrs else ''

    hostname = host.find('hostname')
    if hostname is None:
        if host_attrs['vendor'] == '':
            other_list.append(host)
            continue
        else:
            host_attrs['hostname'] = host_attrs['vendor'] + ' (Vendor)'
    elif 'name' in hostname.attrs:
        host_attrs['hostname'] = hostname.attrs['name']

    print '{}{}|{}{}|{}{}|{}'.format(
        host_attrs['hostname'], add_spaces(30, host_attrs['hostname']),
        host_attrs['ipv4'], add_spaces(18, host_attrs['ipv4']),
        host_attrs['mac'], add_spaces(20, host_attrs['mac']),
        host_attrs['vendor']
    )

print 85 * '-'

if other_list:
    for host in other_list:
        print host
        print 45 * '#'
    print 85 * '-'
