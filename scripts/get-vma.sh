#!/bin/bash

alertsUrl="https://vmaapi.sr.se/api/v3/alerts"

echo "Fetching VMA alerts from $alertsUrl"
response=$(curl -Sv --max-time 60 --connect-timeout 5 --retry 5 --retry-all-errors "$alertsUrl" | jq '.')
echo "Response:"
echo "$response"
echo ""

hash=$(echo "$response" | openssl md5 | awk '{print $2}')

echo "Response hash: $hash"
echo ""

timestamp=$(echo "$response" | jq -r '.timestamp')
alerts=$(echo "$response" | jq '.alerts')

if [ "$timestamp" == "null" ] || [ "$alerts" == "null" ]; then
    echo "Failed to parse alerts"
    exit 0
fi

projectRoot="$(cd "$(dirname "$0")/.." && pwd)"
dataDir="$projectRoot/data/vma"
mkdir -p "$dataDir"

utcTimestamp=$(date -u -d "$timestamp" '+%Y-%m-%dT%H:%M:%S.%3NZ')
[[ $alerts == "[]" ]] && type="quiet" || type="alert"

identifier="${utcTimestamp}_${type}_${hash}"
outputFile="$dataDir/${identifier}.json"

if [ ! -f "$outputFile" ]; then
    echo "Saving VMA alerts to $outputFile"
    echo "$response" > "$outputFile"
    echo "Done! ✅"
else
    echo "Alerts for $identifier already exist, skipping..."
fi