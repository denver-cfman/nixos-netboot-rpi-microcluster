# 1. Force the Pi to use our settings, bypassing automatic PXE/distro discovery
echo "--- Starting Custom Netboot ---"
setenv ethact asix_eth
setenv ipaddr 10.0.83.221
setenv serverip 10.0.83.20

# 2. Correct the device tree path
setenv fdtfile bcm2710-rpi-zero-2.dtb

# 3. Explicitly load files from the root TFTP directory
echo "--- Loading kernel and device tree ---"
tftpboot ${fdt_addr_r} ${fdtfile}
tftpboot ${kernel_addr_r} kernel.img

# 4. Define Kernel Arguments for NFS root
setenv bootargs "console=ttyS0,115200n8 root=/dev/nfs nfsroot=${serverip}:/export/rootfs,vers=3 rw ip=dhcp"

# 5. Boot using the proper command for a standard Image/kernel file
# If your kernel.img is a U-Boot wrapped image, use 'bootm'. 
# If it is a raw Linux kernel (Image), use 'booti'.
echo "--- Booting kernel ---"
booti ${kernel_addr_r} - ${fdt_addr_r}
