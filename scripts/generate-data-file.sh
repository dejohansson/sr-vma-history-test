#! /bin/bash

projectRoot="$(cd "$(dirname "$0")/.." && pwd)"
dataFilePath="$projectRoot/site/data.js"

echo "Creating $dataFilePath"

echo "export const vmaData = [" > "$dataFilePath"
for jsonFile in "$projectRoot/data/vma/"*.json; do
    filename=$(basename "$jsonFile")
    datetime=$(echo "$filename" | cut -d '_' -f 1)
    type=$(echo "$filename" | cut -d '_' -f 2 )
    hash=$(echo "$filename" | cut -d '_' -f 3 | cut -d '.' -f 1)
    echo "  { datetime: \"$datetime\", type: \"$type\", hash: \"$hash\" }," >> "$dataFilePath"
done
echo "];" >> "$dataFilePath"

echo "Done! ✅"