#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Restarting with sudo..."
  sudo "$0" "$@"
  exit 0
fi

# Continue with the rest of your script
echo "Running script with root privileges..."

# Function to extract tar if the target directory doesn't exist
extract_if_not_exists() {
    local tar_file="$1"
    local target_dir="$2"

    if [ ! -d "$target_dir" ]; then
        echo "Directory $target_dir does not exist, extracting $tar_file..."
        mkdir -p "$target_dir"   # Ensure the target directory exists
        tar xzvf "$tar_file" -C "$target_dir" --strip-components=1
    else
        echo "Directory $target_dir already exists, skipping extraction."
    fi
}



# Example setup commands
apt-get update -y
apt-get upgrade
apt-get install -y gcc libcups2-dev libcupsimage2-dev 

#Set Script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get the directory of the script to use absolute paths
TAR_PATH="$SCRIPT_DIR/Star_CUPS_Driver-3.16.0_linux.tar.gz"
EXTRACTED_PATH="$SCRIPT_DIR/Star_CUPS_Driver-3.16.0_linux"

SOURCE_TAR_FILE="$EXTRACTED_PATH/SourceCode/Star_CUPS_Driver-src-3.16.0.tar.gz"
SOURCE_EXTRACTED_PATH="$EXTRACTED_PATH/SourceCode/starcupsdrv"




# Check if the extracted directory already exists

# Extract the main tar file if needed
extract_if_not_exists "$TAR_PATH" "$EXTRACTED_PATH"

# Extract the source tar file if needed
extract_if_not_exists "$SOURCE_TAR_FILE" "$SOURCE_EXTRACTED_PATH"




