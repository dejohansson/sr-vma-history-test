#!/bin/bash

alertsUrl="https://vmaapi.sr.se/api/v3/alerts"
# alertsUrl="https://vmaapi.sr.se/testapi/v3/examples/data"

echo "Fetching VMA alerts from $alertsUrl"
response=$(curl -Sv --max-time 60 --connect-timeout 5 --retry 5 --retry-all-errors "$alertsUrl" | jq '.')
echo "Response:"
echo "$response"
echo ""

timestamp=$(echo "$response" | jq -r '.timestamp')
utcTimestamp=$(date -u -d "$timestamp" '+%Y-%m-%dT%H:%M:%S.%3NZ')
alerts=$(echo "$response" | jq '.alerts')

if [ "$timestamp" == "null" ] || [ "$alerts" == "null" ]; then
    echo "Failed to parse alerts"
    exit 0
fi

projectRoot="$(cd "$(dirname "$0")/.." && pwd)"
dataDir="$projectRoot/data/vma"
mkdir -p "$dataDir"

[[ $alerts == "[]" ]] && suffix="quiet" || suffix="alert"

outputFile="$dataDir/${utcTimestamp}_$suffix.json"

if [ ! -f "$outputFile" ]; then
    echo "Saving VMA alerts to $outputFile"
    echo "$response" > "$outputFile"
    echo "Done! ✅"
else
    echo "Alerts for $utcTimestamp already exist, skipping..."
fi