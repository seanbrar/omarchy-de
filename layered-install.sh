#!/bin/bash

# Omarchy Layered Installation Wrapper
# Use this to install Omarchy as a Desktop Environment layer on an existing Arch system.
# This avoids destructive operations like partitioning or bootloader overwriting.

export OMARCHY_LAYERED_INSTALL=true

# Ensure we're in the right directory
CDIR=$(dirname "$(realpath "$0")")
cd "$CDIR"

# Run the standard installer with the layered flag set
./install.sh

# Create marker file for runtime detection of layered mode
mkdir -p ~/.config/omarchy
touch ~/.config/omarchy/.layered
