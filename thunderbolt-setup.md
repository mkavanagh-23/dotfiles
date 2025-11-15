# Rescan Thunderbolt to Enable PCI Devices on Plug-In
This guide walks through the process of enrolling a thunderbolt device, and setting up a systemd unit and udev rules to rescan the thunderbolt PCI lanes when the device is plugged in or the machine has booted.

## Install Thunderbolt Daemon and Enroll Device
### Install the thunderbolt daemon
```
sudo pacman -S bolt
sudo systemctl enable --now boltd.service
```
### Enroll the device
- Find the device UUID:
```
sudo boltctl list
```
- Enroll the device
```
sudo boltctl authorize {DEVICE_UUID}
sudo boltctl enroll {DEVICE_UUID}
```

## Create the systemd unit file and enable it to run at boot-time
- Create a new systemd unit file in `/etc/systemd/system/thunderbolt-rescan.service'
```
[Unit]
Description=Force PCI rescan for Thunderbolt device
After=bolt.service
Wants=bolt.service

[Service]
Type=oneshot
ExecStart=/usr/bin/sh -c 'sleep 1; echo 1 > /sys/bus/pci/rescan'

[Install]
WantedBy=multi-user.target
```
- Emable the unit file to run at boot:
```
sudo systemctl daemon-reload
sudo systemctl enable thunderbolt-rescan.service
```

## Create a udev rule to trigger the unit file when a thunderbolt device is hotplugged
- Create the udev rule at `/etc/udev/rules.d/99-thunderbolt-rescan.rules`
```
ACTION=="add", SUBSYSTEM=="thunderbolt", ENV{SYSTEMD_WANTS}="thunderbolt-rescan.service"
```
- Reload the udev daemon:
```
sudo udevadm control --reload-rules
```
