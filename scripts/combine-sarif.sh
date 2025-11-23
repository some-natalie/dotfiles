#!/bin/bash

if [ "$#" -lt 2 ]; then
  echo "You must pass two file names to merge two files"
  echo "Usage: $0 file1 file2"
  exit 1
fi

mergeInto="$1"
mergeFrom="$2"

function get_rules() {
  local sarif_file="$1"
  jq '.runs[0].tool.driver.rules' "$sarif_file"
}

function get_results() {
  local sarif_file="$1"
  jq '.runs[0].results' "$sarif_file"
}

function is_empty_sarif() {
  local sarif_file="$1"
  [ "$(jq '.runs[0].tool.driver.rules | length' "$sarif_file")" -eq 0 ] && \
  [ "$(jq '.runs[0].results | length' "$sarif_file")" -eq 0 ]
}

function merge_sarif() {
  local file1="$1"
  local file2="$2"

  if is_empty_sarif "$file1" && is_empty_sarif "$file2"; then
    echo "Both SARIF files are empty. Skipping merge."
    return 0
  fi

  local j1
  j1=$(cat "$file1")

  local j2
  j2=$(cat "$file2")

  local rules1
  rules1=$(echo "$j1" | jq '.runs[0].tool.driver.rules')

  local rules2
  rules2=$(echo "$j2" | jq '.runs[0].tool.driver.rules')

  local results1
  results1=$(echo "$j1" | jq '.runs[0].results')

  local results2
  results2=$(echo "$j2" | jq '.runs[0].results')

  echo "$mergeInto rules found: $(echo "$rules1" | jq 'length')"
  echo "$mergeInto locations found: $(echo "$results1" | jq 'length')"
  echo "$mergeFrom rules found: $(echo "$rules2" | jq 'length')"
  echo "$mergeFrom locations found: $(echo "$results2" | jq 'length')"

  local combined_rules
  combined_rules=$(jq -s '.[0] + .[1]' <(echo "$rules1") <(echo "$rules2"))

  local unique_rules
  unique_rules=$(echo "$combined_rules" | jq 'unique_by(.id)')

  echo "Number of rules combined is: $(echo "$unique_rules" | jq 'length')"

  local combined_results
  combined_results=$(jq -s '.[0] + .[1]' <(echo "$results1") <(echo "$results2"))

  jq '.runs[0].tool.driver.rules = '"$unique_rules"' | .runs[0].results = '"$combined_results" "$file1" > all_results.sarif

  echo "Number of source locations combined is: $(echo "$combined_results" | jq 'length')"
}

merge_sarif "$mergeInto" "$mergeFrom"
