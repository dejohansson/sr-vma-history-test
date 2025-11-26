#! /bin/bash

projectRoot="$(cd "$(dirname "$0")/.." && pwd)"

"$projectRoot/scripts/generate-data-file.sh"

echo "Set version in index.html"

timestamp=$(date +%Y%m%d%H%M%S)
sed -i "s/data\.js?v=VERSION_PLACEHOLDER/data\.js?v=${timestamp}/" "$projectRoot/site/index.html"

echo "Done! ✅"