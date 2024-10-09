#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Restarting with sudo..."
  sudo "$0" "$@"
  exit 0
fi

# Continue with the rest of your script
echo "Running script with root privileges..."

#Set Script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



# Example setup commands
apt-get update -y
apt-get upgrade
apt-get install -y gcc libcups2-dev libcupsimage2-dev 


# Define variables for printer driver install
TAR_FILE="Star_CUPS_Driver-3.16.0_linux.tar.gz"
EXTRACTED_DIR="Star_CUPS_Driver-3.16.0_linux"

# Get the directory of the script to use absolute paths
TAR_PATH="$SCRIPT_DIR/$TAR_FILE"
EXTRACTED_PATH="$SCRIPT_DIR/$EXTRACTED_DIR"

# Check if the extracted directory already exists
echo "Checking if directory exists: $EXTRACTED_PATH"
if [ -d "$EXTRACTED_PATH" ]; then
    echo "The directory $EXTRACTED_DIR already exists. Skipping extraction."
else
    # If not extracted, proceed with extraction
    if [ -f "$TAR_PATH" ]; then
        echo "File found: $TAR_FILE. Extracting..."
        tar xzvf "$TAR_PATH"
        echo "Extraction complete!"
    else
        echo "$TAR_FILE not found in $SCRIPT_DIR. Exiting..."
        exit 1
    fi
fi




