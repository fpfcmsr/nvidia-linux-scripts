switch nvidia driver to vfio-pci (for vm use) and from vfio-pci to nvidia (for host use)
assumes that at boot time vfio-pci is the driver loaded and there is nvidia-blacklist.conf file and a vfio.conf file that facilitate this
