#!/bin/bash
# Script to clean buildroot configuration and output
# Author: Ricardo Alvarez

set -e

# Go to the directory of the script
cd "$(dirname "$0")"

# Check if the buildroot directory exists
if [ ! -d buildroot ]; then
    echo "ERROR: 'Buildroot' directory was not found."
    exit 1
fi

echo "Executing make clean..."
make -C buildroot distclean
