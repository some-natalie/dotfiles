#!/usr/bin/env python3

"""
This script outputs a table of results from the grype tool across all images
in a text file.

Input: A text file containing a list of image names.

Example of the input file format:
$ cat images.txt
registry.path/image1:tag
image2:tag

Run the script:
$ python3 grype-table.py images.txt

Output:
- A table of results from the grype tool to the console
"""

import sys
import subprocess
import json
from collections import Counter
from tabulate import tabulate

# if no text file is provided, print the usage and exit
if len(sys.argv) != 2:
    print("Usage: python3 grype-summation.py images.txt")
    sys.exit(1)

# read the input file
with open(sys.argv[1], "r") as f:
    images = f.readlines()

# create a list to store the results
final_results = []

# for each image, run the grype tool silently and save the summary
for image in images:
    image = image.strip()
    print(f"Analyzing {image}...")

    # run grype
    raw_result = subprocess.run(
        ["grype", image, "-o", "json", "-q"], stdout=subprocess.PIPE
    )
    raw_result = json.loads(raw_result.stdout.decode("utf-8"))

    # extract severity values
    severity_values = [
        match["vulnerability"]["severity"] for match in raw_result["matches"]
    ]

    # sort and count unique values for this image
    severity_counts = Counter(severity_values)

    # append the results to the final list
    final_results.append(
        {
            "image": image,
            "severity_counts": severity_counts,
        }
    )

severity_levels = ["Critical", "High", "Medium", "Low", "Negligible", "Unknown"]

# a little post-processing here to
# - convert Counters to dicts
# - put a "0" value for missing severity levels
for result in final_results:
    result["severity_counts"] = dict(result["severity_counts"])
    for severity in severity_levels:
        if severity not in result["severity_counts"]:
            result["severity_counts"][severity] = 0

# prep for table format
table_data = []
headers = ["Image"] + severity_levels
for item in final_results:
    row = [item["image"]]
    for severity in headers[1:]:
        row.append(item["severity_counts"].get(severity, 0))
    table_data.append(row)

# print the table
print(tabulate(table_data, headers=headers, tablefmt="pretty"))
