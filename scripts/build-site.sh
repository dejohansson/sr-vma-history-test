#! /bin/bash

# Run the data file generation script
./scripts/generate-data-file.sh

# Replace 'from "./data.js?v=VERSION_PLACEHOLDER";'' in site/index.html with the current timestamp to bust cache
timestamp=$(date +%Y%m%d%H%M%S)
sed -i "s/data\.js?v=VERSION_PLACEHOLDER/data\.js?v=${timestamp}/" site/index.html