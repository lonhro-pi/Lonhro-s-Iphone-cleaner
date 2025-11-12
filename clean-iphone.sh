#!/bin/bash

# iPhone Duplicate Cleaner for Linux
# Removes duplicate photos and videos from iPhone

set -e

echo "==================================="
echo "iPhone Duplicate Cleaner for Linux"
echo "==================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please don't run this script as root"
   exit 1
fi

# Check for required tools
echo "[1/6] Checking required tools..."
MISSING_TOOLS=()

if ! command -v idevice_id &> /dev/null; then
    MISSING_TOOLS+=("libimobiledevice-utils")
fi

if ! command -v ifuse &> /dev/null; then
    MISSING_TOOLS+=("ifuse")
fi

if ! command -v fdupes &> /dev/null; then
    MISSING_TOOLS+=("fdupes")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "Missing tools: ${MISSING_TOOLS[*]}"
    echo "Installing required packages..."
    sudo apt update
    sudo apt install -y libimobiledevice6 libimobiledevice-utils ifuse usbmuxd fdupes
    echo "Tools installed successfully!"
else
    echo "All required tools are installed."
fi

# Detect iPhone
echo ""
echo "[2/6] Detecting iPhone..."
DEVICE_ID=$(idevice_id -l | head -n 1)

if [ -z "$DEVICE_ID" ]; then
    echo "ERROR: No iPhone detected."
    echo "Please:"
    echo "  1. Connect your iPhone via USB"
    echo "  2. Unlock your iPhone"
    echo "  3. Tap 'Trust This Computer' when prompted"
    exit 1
fi

echo "iPhone detected: $DEVICE_ID"

# Create mount point
MOUNT_POINT="$HOME/iphone_mount"
echo ""
echo "[3/6] Creating mount point..."
mkdir -p "$MOUNT_POINT"

# Mount iPhone
echo ""
echo "[4/6] Mounting iPhone..."
ifuse "$MOUNT_POINT"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to mount iPhone"
    exit 1
fi

echo "iPhone mounted at $MOUNT_POINT"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "[6/6] Unmounting iPhone..."
    fusermount -u "$MOUNT_POINT" 2>/dev/null || true
    echo "Done! You can safely disconnect your iPhone."
}

trap cleanup EXIT

# Scan and remove duplicates
echo ""
echo "[5/6] Scanning for duplicates..."
echo "This may take a few minutes depending on how many files you have..."
echo ""

# Check DCIM folder (photos/videos)
if [ -d "$MOUNT_POINT/DCIM" ]; then
    echo "Scanning photos and videos in DCIM..."
    DUPLICATES=$(fdupes -r "$MOUNT_POINT/DCIM" | grep -c "^/" || echo "0")
    
    if [ "$DUPLICATES" -gt 0 ]; then
        echo "Found duplicate files. Removing duplicates (keeping one copy of each)..."
        fdupes -r -d -N "$MOUNT_POINT/DCIM"
        echo "✓ Duplicates removed from photos/videos"
    else
        echo "✓ No duplicates found in photos/videos"
    fi
else
    echo "⚠ DCIM folder not found"
fi

# Check Downloads folder
if [ -d "$MOUNT_POINT/Downloads" ]; then
    echo ""
    echo "Scanning Downloads..."
    DOWNLOADS_DUPS=$(fdupes -r "$MOUNT_POINT/Downloads" | grep -c "^/" || echo "0")
    
    if [ "$DOWNLOADS_DUPS" -gt 0 ]; then
        echo "Found duplicate files in Downloads. Removing duplicates..."
        fdupes -r -d -N "$MOUNT_POINT/Downloads"
        echo "✓ Duplicates removed from Downloads"
    else
        echo "✓ No duplicates found in Downloads"
    fi
fi

echo ""
echo "==================================="
echo "Cleanup complete!"
echo "==================================="
