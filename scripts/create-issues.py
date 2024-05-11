#!/usr/bin/env python3

"""
This script creates issues with an identical body in a GitHub repository.

Inputs:
- GitHub PAT (Personal Access Token)
- Repository name
- Customer name
- List of issue titles
- List of issue labels to apply to all issues
- Issue body
"""

# Imports
import requests

# Inputs
with open("token.txt") as token:
    token = token.read().replace("\n", "")
repo = "owner/repo"
customer = "customer"  # used as a naming convention to start the issue title
with open("issue-titles.txt") as titles:
    titles = titles.read().splitlines("\n")
labels = [
    "good first issue",
    "bug",
    "enhancement",
]  # all of these will be applied to each issue
with open("issue-body.txt") as body:
    body = (
        body.read()
    )  # this will be the body of each issue, can be GitHub-flavored Markdown
assignee = "some-natalie"  # assignee(s) for all issues, don't include the "@" symbol
gh_api = "https://api.github.com"  # change for GHES

# Set the request parameters
headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "Bearer " + str(token),
    "X-GitHub-Api-Version": "2022-11-28",
}

# Do the thing
if __name__ == "__main__":
    for title in titles:
        data = {
            "title": customer + ": " + title,
            "body": body,
            "labels": labels,
            "assignee": assignee,
        }
        response = requests.post(
            f"{gh_api}/repos/{repo}/issues", headers=headers, json=data
        )
        if response.status_code == 201:
            print(f"Created issue: {title}")
        else:
            print(f"Error: {response.status_code} {response.text}")
