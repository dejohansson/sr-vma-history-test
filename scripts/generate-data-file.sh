#! /bin/bash

# Create data.js with vmaData array export based on the JSON files in data/vma/
echo "export const rawData = [" > site/data.js
for file in data/vma/*.json; do
  cat "$file" >> site/data.js
  echo "," >> site/data.js
done
echo "];" >> site/data.js