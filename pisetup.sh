#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Restarting with sudo..."
  sudo "$0" "$@"
  exit 0
fi

#Set Script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Continue with the rest of your script
echo "Running script with root privileges..."

# Function to extract tar if the target directory doesn't exist
extract_if_not_exists() {
  local tar_file="$1"
  local target_dir="$2"

  if [ ! -d "$target_dir" ]; then
    echo "Directory $target_dir does not exist, extracting $tar_file..."
    mkdir -p "$target_dir" # Ensure the target directory exists
    tar xzvf "$tar_file" -C "$target_dir" --strip-components=1
  else
    echo "Directory $target_dir already exists, skipping extraction."
  fi
}

# Example setup commands
apt-get update -y
apt-get upgrade
apt-get install -y gcc libcups2-dev libcupsimage2-dev cups

# Configure Cups
cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.original
chmod a-w /etc/cups/cupsd.conf.original

# Get the directory of the script to use absolute paths
TAR_PATH="$SCRIPT_DIR/Star_CUPS_Driver-3.16.0_linux.tar.gz"
EXTRACTED_PATH="$SCRIPT_DIR/Star_CUPS_Driver-3.16.0_linux"

#Printer ddrivers Source
SOURCE_TAR_FILE="$EXTRACTED_PATH/SourceCode/Star_CUPS_Driver-src-3.16.0.tar.gz"
SOURCE_EXTRACTED_PATH="$EXTRACTED_PATH/SourceCode/starcupsdrv"

# Define some expected binaries or output files
EXPECTED_BINARY="/usr/share/cups/model/star/tsp143.ppd"     # Replace with actual binary or path
EXPECTED_BUILD_FILE="$SOURCE_EXTRACTED_PATH/ppd/tsp143.ppd" # Replace with an actual file created by make

# Check if the extracted directory already exists

# Extract the main tar file if needed
extract_if_not_exists "$TAR_PATH" "$EXTRACTED_PATH"

# Extract the source tar file if needed
extract_if_not_exists "$SOURCE_TAR_FILE" "$SOURCE_EXTRACTED_PATH"

# Check if Makefile exists in the extracted source directory
if [ -f "$SOURCE_EXTRACTED_PATH/makefile" ]; then
  echo "Makefile found. Running 'make' and 'make install'..."

  # Navigate to the directory containing the Makefile
  cd "$SOURCE_EXTRACTED_PATH"

  # Run make and make install
  # Check if the build file exists, indicating that 'make' has already been run
  if [ ! -f "$EXPECTED_BUILD_FILE" ]; then
    echo "Makefile found and build files missing. Running 'make'..."

    # Navigate to the directory containing the Makefile
    cd "$SOURCE_EXTRACTED_PATH"

    # Run make
    make
    if [ $? -eq 0 ]; then
      echo "Make completed successfully."
    else
      echo "Make failed. Exiting."
      exit 1
    fi
  else
    echo "'make' has already been run (build file found). Skipping 'make'."
  fi

  # Check if the program has already been installed
  if [ ! -f "$EXPECTED_BINARY" ]; then
    echo "'make install' has not been run. Running 'make install'..."

    # Run make install
    sudo make install
    if [ $? -eq 0 ]; then
      echo "'make install' completed successfully."
    else
      echo "'make install' failed. Exiting."
      exit 1
    fi
  else
    echo "'make install' has already been run (binary found). Skipping 'make install'."
  fi
else
  echo "Makefile not found in $SOURCE_EXTRACTED_PATH. Exiting."
  exit 1
fi
