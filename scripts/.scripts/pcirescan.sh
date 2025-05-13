#!/bin/bash
# A script to rescan pci devices, run as root

echo 1 | tee /sys/bus/pci/rescan > /dev/null
if [[ $? == 0 ]]; then
  echo "PCI devices rescanned successfully."
  exit 0
fi

exit 1
