#! /bin/bash

projectRoot="$(cd "$(dirname "$0")/.." && pwd)"
dataFilePath="$projectRoot/site/data.js"

echo "Generating creating $dataFilePath"

echo "export const vmaData = [" > "$dataFilePath"
for jsonFile in "$projectRoot/data/vma/"*.json; do
    filename=$(basename "$jsonFile")
    datetime="${filename%%_*}"
    type="${filename#*_}"
    type="${type%.json}"
    echo "  { datetime: \"$datetime\", type: \"$type\" }," >> "$dataFilePath"
done
echo "];" >> "$dataFilePath"

echo "Done! ✅"