#!/usr/bin/env python3

"""
This script will programmatically suspend all dormant users in a GHES instance.  To do this, it will:
1. Pull the `dormant_users` report from the GHES instance.
2. Suspend all dormant users in the report.

Does not work on LDAP users.
"""

# Imports
import requests
from time import sleep

# Set inputs
ghes_url = "github.contoso.com"
ghes_pat = "github_pat"  # needs to have site_admin scope

# Set proper headers
headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "token " + ghes_pat,
}


# Get the dormant_users report
def get_dormant_users(ghes_url, headers):
    print(f"Requesting dormant_users report from {ghes_url} ...")
    report_url = f"https://{ghes_url}/stafftools/reports/dormant_users.csv"
    response = requests.get(report_url, headers=headers)
    if not response.ok:
        raise Exception(response.status_code, response.text)
    wait_time = 0
    if response.status_code == 202:  # report needs to be generated
        print("Waiting a minute for the report to be generated ...")
        while response.status_code == 202:
            print(f"Waited {wait_time} minutes so far ...")
            sleep(60)
            wait_time += 1
            response = requests.get(report_url, headers=headers)
            while response.status_code == 202:
                continue
    elif (
        response.status_code == 200
    ):  # report is ready, save the column we want as a list
        lines = response.text.splitlines()
        users = []
        for line in lines[1:]:  # skip first line (has headers)
            username = line.split(",")[2]  # only grab the third column (login)
            users.append(username)
        return users


# Suspend all dormant users
def suspend_user(ghes_url, headers, username):
    print(f"Suspending {username} ...")
    suspend_url = f"https://{ghes_url}/api/v3/users/{username}/suspended"
    response = requests.put(suspend_url, headers=headers)
    if not response.ok:
        raise Exception(response.status_code, response.text)


# Do the things!
if __name__ == "__main__":
    users = get_dormant_users(ghes_url, headers)
    print(f"Suspending {len(users)} dormant users ...")
    for user in users:
        suspend_user(ghes_url, headers, user)
