#!/bin/bash
# run as superuser

# do ctrl + alt + f1 to get out of graphical session
# on different systems maybe its ctrl + alt + f2 etc..

systemctl isolate multi-user.target

## Load the config file
rm /etc/modprobe.d/blacklist-nvidia.conf
rm /etc/modprobe.d/vfio.conf

## Unbind gpu from vfio and bind to nvidia
virsh nodedev-reattach pci_0000_01_00_0 #this is specific to my driver, do lspci -vvvnn and look for nvidia to see what yours are

## Unload vfi#
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

modprobe -i nvidia

systemctl unmask nvidia-persistenced
systemctl enable nvidia-persistenced
systemctl start nvidia-persistenced

systemctl start graphical.target

#sudo rm /etc/modprobe.d/blacklist-nvidia.conf && sudo rm /etc/modprobe.d/vfio.conf && sudo virsh nodedev-reattach pci_0000_01_00_0 && sudo modprobe -r vfio_pci && sudo modprobe -r vfio_iommu_type1 && sudo modprobe -r vfio && sudo modprobe -i nvidia && sudo systemctl unmask nvidia-persistenced && sudo systemctl enable nvidia-persistenced && sudo systemctl start nvidia-persistenced
