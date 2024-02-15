#!/usr/bin/env python3

"""
*** RUN https://github.com/some-natalie/gh-org-admin-promote FIRST ***
^^ will promote an enterprise admin to own all organizations in the enterprise, needed
to pull the active GHAS contribution data for each organization.

This script will programmatically generate a report of all active GHAS
committers in a GHES instance.  To do this, it will:

1. Pull the `all_organization` report from the GHES instance.
2. Promote the user running this script to org owner on all of these organizations.
3. Pull the active GHAS contribution data for each organization and dump it into a CSV file.

This script takes 2 inputs:

- ghes_url = "github.contoso.com"
- ghes_pat = "github_pat"  # needs to have `admin:org` and `site_admin` scopes

It outputs a CSV file with the following columns:
- User login
- Organization / repository
- Last push date
"""

# Imports
import requests
import csv
from time import sleep

# Set inputs
ghes_url = "github.contoso.com"
ghes_pat = "github_pat"

# Set proper headers
headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "token " + ghes_pat,
}

# Get the all_organizations report
print(f"Requesting all_organizations report from {ghes_url} ...")
report_url = f"https://{ghes_url}/stafftools/reports/all_organizations.csv"
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
elif response.status_code == 200:  # report is ready, save the column we want as a list
    lines = response.text.splitlines()
    orgs = []
    for line in lines[1:]:  # skip first line (has headers)
        org = line.split(",")[2]
        orgs.append(org)


# Set up the CSV file
with open("active_ghas_committers.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerow(["User login", "Organization / repository", "Last push date"])


# For each organization, get the active GHAS committers and dump it to CSV
for org in orgs:
    print(f"Requesting active GHAS committers for {org} ...")
    url = f"https://{ghes_url}/api/v3/orgs/{org}/settings/billing/advanced-security"
    print(url)
    response = requests.get(url, headers=headers)
    if response.status_code == 403:
        pass  # org doesn't have GHAS
    elif response.status_code == 404:
        print(
            f"Organization {org} does not exist! Investigate further, skipping for now ..."
        )
        pass  # org doesn't exist??
    elif response.status_code == 200:
        if response.json()["total_advanced_security_committers"] == 0:
            pass  # no active GHAS committers
        repos = []
        for repo in response.json()["repositories"]:
            repos.append(repo)
        while next_url := response.links.get("next", {}).get("url"):
            response = requests.get(next_url, headers=headers)
            if not response.ok:
                raise Exception(response.status_code, response.text)
            for repo in response.json()["repositories"]:
                repos.append(repo)
        for repo in repos:
            print(repo)
            if repo["advanced_security_committers_breakdown"] is not None:
                for user in repo["advanced_security_committers_breakdown"]:
                    with open("active_ghas_committers.csv", "a") as f:
                        writer = csv.writer(f)
                        writer.writerow(
                            [
                                user["user_login"],
                                repo["name"],
                                repo["advanced_security_committers_breakdown"][0][
                                    "last_pushed_date"
                                ],
                            ]
                        )
    else:
        raise Exception(response.status_code, response.text)

# Close the CSV file
f.close()
print(f"Done writing active_ghas_committers.csv!")
