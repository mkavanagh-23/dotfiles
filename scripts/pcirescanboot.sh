#!/bin/bash
# A script to rescan pci devices, run as root
	
sleep .4
echo 1 > /sys/bus/pci/rescan

exit 0
