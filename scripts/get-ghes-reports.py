#!/usr/bin/env python3

import requests
from time import sleep

# Set the request parameters
ghes_url = "github.contoso.com"
ghes_pat = "github_pat"  # needs to have site_admin scope
report_type = "all_users.csv"

# valid report types are:
#   all_users.csv
#   active_users.csv
#   dormant_users.csv
#   suspended_users.csv
#   all_organizations.csv
#   all_repositories.csv

# Set proper headers
headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "token " + ghes_pat,
}

# Get the report, sleeping for 60 seconds if it returns a 202
url = f"https://{ghes_url}/stafftools/reports/{report_type}"
response = requests.get(url, headers=headers)
if not response.ok:
    raise Exception(response.status_code, response.text)
wait_time = 0
if response.status_code == 202:  # report needs to be generated
    print("Waiting a minute for the report to be generated ...")
    while response.status_code == 202:
        print(f"Waited {wait_time} minutes so far ...")
        sleep(60)
        wait_time += 1
        response = requests.get(url, headers=headers)
        while response.status_code == 202:
            continue
elif response.status_code == 200:  # report is ready, write to disk
    print("Report is ready!  Saving to disk now ...")
    with open(report_type, "wb") as f:
        f.write(response.content)
else:  # something went wrong with fetching the report
    exit(f"Error: {response.status_code} {response.text}")
