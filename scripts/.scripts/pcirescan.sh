#!/bin/bash
# A script to rescan pci devices, run as root

USER_CALLER="${SUDO_USER:-$LOGNAME}"

echo 1 | tee /sys/bus/pci/rescan > /dev/null
if [[ $? == 0 ]]; then
  echo "PCI devices rescanned successfully."
  runuser -u $USER_CALLER -- notify-send " System" "PCI devices rescanned"
  exit 0
fi

exit 1
