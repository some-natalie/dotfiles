#!/usr/bin/env python3

"""
This simple script just searches using GitHub's search REST API and returns a
de-duped list of matching repositories to the console.  Note that if you want
to search _all_ code, you'll need to run `ghe-org-admin-promote` at the console
or use https://github.com/some-natalie/gh-org-admin-promote first!

Docs:
https://docs.github.com/en/rest/reference/search
"""

import requests

with open('token.txt') as token:
    token = token.read().replace('\n', '')

headers = {"Accept": "application/vnd.github.v3+json",
           "Authorization": "Bearer " + str(token)}

query = "filename:dependabot.yml"

url = "https://GHES-FQDN/api/v3/search/code"

r = requests.get(url + "?q=" + query, headers=headers)

data = r.json()
repo_list = []
for i in data['items']:
    if i['repository']['full_name'] not in repo_list:
        repo_list.append(i['repository']['full_name'])
print("There are " + str(len(repo_list)) + " repos matching query:\n")
print(*repo_list, sep="\n")
