# 1. Wait for USB/Ethernet hardware to stabilize
echo "--- Initializing Hardware ---"
sleep 5

# 2. Configure Network
echo "--- Configuring Network ---"
dhcp
# Ensure we use the detected USB Ethernet device
setenv ethact asix_eth0

# 3. Define path variables
# Ensure these filenames match the files in your /var/lib/tftpboot/
setenv fdtfile bcm2710-rpi-zero-2.dtb
setenv kernel_file kernel.img

# 4. Load files into memory
echo "--- Loading Boot Files ---"
tftpboot ${fdt_addr_r} ${fdtfile}
tftpboot ${kernel_addr_r} ${kernel_file}

# 5. Set Kernel Arguments
# root=/dev/nfs is required for network booting
setenv bootargs "console=ttyS0,115200n8 root=/dev/nfs nfsroot=${serverip}:/export/rootfs,vers=3 rw ip=dhcp"

# 6. Execute Boot
# Use 'booti' for ARM64 Linux kernels. 
# The '-' parameter is for the ramdisk (none in this case).
echo "--- Booting Kernel ---"
booti ${kernel_addr_r} - ${fdt_addr_r}
