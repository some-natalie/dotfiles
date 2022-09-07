#!/usr/bin/env python3

"""
This script pulls a list of all repositories owned by a given organization,
then does the following:
- Clones them all to a target local directory
- Pulls the LFS files down

Arguments needed to run:
  - gh_org - organization on GHE to get all repos
  - gh_user - username to log in as for GHE, needs to see all the repos in org
  - gh_token - token to use to log in for GHE, needs to read repos and that's it
  - gh_url - URL to GHES instance, use https://api.github.com for github.com
"""

# Import all the things
import os
import requests
import subprocess

# Read all the arguments
gh_org = "orgnamehere"
gh_user = "usernamehere"
gh_token = "patgoeshere"
gh_url = "https://GHES-FQDN/api/v3"

# Set requests headers
gh_headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "token " + str(gh_token),
}

# Get a list of repositories for the export organization
repo_list = []
for j in range(1, 100):  # kludgy pagination workaround
    repo_query = requests.get(
        gh_url + "/orgs/" + gh_org + "/repos?page=" + str(j), headers=gh_headers
    )
    data = repo_query.json()
    for i in range(len(data)):
        repo_name = data[i]["name"]
        repo_list.append(repo_name)
print("There are " + str(len(repo_list)) + " repositories in " + str(gh_org))

for i in repo_list:
    # Print the name of the repo to the console
    print("Now migrating = " + str(i))
    # Clone it down to transfer directory
    gh_clone_url = (
        "https://"
        + str(gh_token)
        + "@"
        + str(gh_url).rstrip("api/v3")
        + str(gh_org)
        + "/"
        + str(i)
        + ".git"
    )
    subprocess.run(
        "GIT_SSL_NO_VERIFY=true git clone --mirror " + str(gh_clone_url), shell=True
    )
    # Now pull down the LFS info
    os.chdir(str(i) + ".git")
    # Fetch those files
    subprocess.run("GIT_SSL_NO_VERIFY=true git lfs fetch origin --all", shell=True)
    # Get back to the parent directory
    os.chdir("..")

# Now bundle it all up
subprocess.run("tar czf lfs-export.tar.gz *.git", shell=True)
