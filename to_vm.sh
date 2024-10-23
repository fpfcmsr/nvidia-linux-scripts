#!/bin/bash

#run as superuser

systemctl isolate multi-user.target

# do ctrl + alt + f1 to get out of graphical session
# on different systems maybe its ctrl + alt + f2 etc..

touch /etc/modprobe.d/blacklist-nvidia.conf

echo 'blacklist nouveau
alias nouveau off

blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_uvm
blacklist nvidia_modeset
blacklist nvidia_current
blacklist nvidia_current_drm
blacklist nvidia_current_uvm
blacklist nvidia_current_modeset

alias nvidia off
alias nvidia_drm off
alias nvidia_uvm off
alias nvidia_modeset off
alias nvidia_current off
alias nvidia_current_drm off
alias nvidia_current_uvm off
alias nvidia_current_modeset off' | sudo tee -a /etc/modprobe.d/blacklist-nvidia.conf

touch /etc/modprobe.d/vfio.conf
echo 'options vfio-pci ids=10de:24b7,10de:228b
softdep nvidia pre: vfio-pci
options kvm ignore_msrs=1' | sudo tee -a /etc/modprobe.d/vfio.conf

dracut -f

systemctl stop nvidia-persistenced
systemctl disable nvidia-persistenced
systemctl mask nvidia-persistenced

pkill nvidia

systemctl isolate multi-user.target

## Load vfio
modprobe vfio
modprobe vfio_iommu_type1
modprobe vfio_pci

modprobe -rf nvidia_uvm
modprobe -rf nvidia_drm
modprobe -rf nvidia_modeset
modprobe -rf nvidia

## Unbind gpu from nvidia and bind to vfio
virsh nodedev-detach pci_0000_01_00_0  #this is specific to my driver, do lspci -vvvnn and look for nvidia to see what yours are

systemctl start graphical.target

exit
