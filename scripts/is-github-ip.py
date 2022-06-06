#!/usr/bin/env python3

"""
Quick script to check if a given IP is a GitHub.com IP address using the `meta` API.
https://docs.github.com/en/rest/meta#get-github-meta-information
"""

# imports
import ipaddress
import requests
import sys

# get the ip address to check
check = sys.argv[1]

# grab the latest ip list and parse
iplist = requests.get("https://api.github.com/meta").json()


# check if the ip is in the list
def in_cidr(ip, cidr):
    """
    Check if an IP is in a CIDR.
    """
    return ipaddress.ip_address(ip) in ipaddress.ip_network(cidr)


# check if the ip is in the list
for service in [
    iplist["hooks"],
    iplist["web"],
    iplist["api"],
    iplist["git"],
    iplist["packages"],
    iplist["pages"],
    iplist["importer"],
    iplist["actions"],
    iplist["dependabot"],
]:
    for cidr_block in service:
        if in_cidr(check, cidr_block):
            print("Yes, this is a GitHub IP address.")
            sys.exit(0)
        else:
            continue

print("No, this is not a GitHub IP address.")
