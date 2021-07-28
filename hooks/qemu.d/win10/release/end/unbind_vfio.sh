#!/bin/bash
set -x
## Load the config file
source "/etc/libvirt/hooks/kvm.conf"


## Load vfio
modprobe -r vfio
modprobe -r vfio_iommu_type1
modprobe -r vfio_pci


## Unbind gpu from nvidia and bind to vfio
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

nvidia-xconfig --query-gpu-info > /dev/null 2>&1



echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind


# Unbind VTconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind


modprobe nvidia_drm
modprobe nvidia_modeset
modprobe drm_kms_helper
modprobe nvidia
modprobe i2c_nvidia_gpu
modprobe drm
modprobe nvidia_uvm


systemctl start gdm3.service
