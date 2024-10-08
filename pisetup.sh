#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Restarting with sudo..."
  sudo "$0" "$@"
  exit 0
fi

# Continue with the rest of your script
echo "Running script with root privileges..."

# Example setup commands
apt-get update -y
apt-get upgrade
apt-get install -y
