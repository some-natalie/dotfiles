#!/usr/bin/env python3

"""
This script will output a CSV file of all available Chainguard images.

The CSV file will contain the following columns:
- Image Name
- FIPS (if the image is a FIPS image)
- Tags

Dependencies:
- chainctl (https://edu.chainguard.dev/chainguard/administration/how-to-install-chainctl/)
- crane (https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md#installation)

Input:
- Your Chainguard private registry, e.g. "chainguard-private"
"""

import csv
import json
import subprocess

registry = ""

# Get the list of images
images = json.loads(
    subprocess.check_output(
        [
            "chainctl",
            "img",
            "repos",
            "list",
            "--parent",
            registry,
            "-o",
            "json",
        ]
    )
)

# Make the CSV file
with open("chainguard-images.csv", "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["Image Name", "FIPS", "Tags"])
    for image in images["items"]:
        tags = subprocess.check_output(
            [
                "crane",
                "ls",
                "cgr.dev/{0}/{1}".format(registry, image["name"]),
                "--omit-digest-tags",
            ]
        )
        tags = tags.decode("utf-8").split("\n")
        writer.writerow(
            [
                # name
                image["name"],
                # if name contains "-fips" then it is a FIPS image
                "FIPS" if "-fips" in image["name"] else "non-fips",
                # tags
                tags,
            ]
        )
