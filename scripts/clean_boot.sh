#!/usr/bin/env bash
# Exit the script if any error occurs
set -e

# Verify that it is running with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script requires administrator privileges. Run it with sudo." 
   exit 1
fi

echo "=== Starting maintenance of /boot and Kernels ==="
echo "Kernel currently in use: $(uname -r)"
echo "---------------------------------------------------"

# 1. Purge kernels and orphan dependencies
# Debian already knows which kernels to protect (the current one in memory and the most recently installed)
echo "[*] Cleaning obsolete kernels and orphan dependencies..."
apt-get autoremove --purge -y

# 2. Removing residual configuration files
# Search for packages marked with 'rc' (remove/config-files) that left garbage on the disk
echo "[*] Searching for and removing residual configurations..."
RESIDUAL_PACKAGES=$(dpkg -l | grep '^rc' | awk '{print $2}')

if [[ -n "$RESIDUAL_PACKAGES" ]]; then
    echo "Purging the following residual packages:"
    echo "$RESIDUAL_PACKAGES"
    # xargs helps pass the list of packages safely to apt-get
    echo "$RESIDUAL_PACKAGES" | xargs apt-get purge -y
else
    echo "No residual packages were found."
fi

# 3. Update GRUB
echo "[*] Updating GRUB configuration..."
update-grub

# 4. Final report
echo "---------------------------------------------------"
echo "=== Final state of the /boot partition ==="
df -h /boot
echo ""
echo "=== Kernel images remaining in the system ==="
dpkg --list | grep -E 'ii  linux-image-[0-9]+' | awk '{print $2, $3}'
echo "=== Maintenance completed ==="