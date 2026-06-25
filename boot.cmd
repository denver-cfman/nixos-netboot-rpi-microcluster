echo "--- Starting Netboot for RPi Zero 2 W ---"
# Set the correct DTB filename that you see in your 'ls' output
setenv fdtfile bcm2710-rpi-zero-2.dtb

# Ensure the server and IP are correctly referenced
setenv serverip 10.0.83.20
setenv ipaddr 10.0.83.221

# Load files explicitly
tftpboot ${fdt_addr_r} ${fdtfile}
tftpboot ${kernel_addr_r} kernel.img

# BOOT! Use 'bootm' if it's a wrapped u-boot image, or 'booti' for a raw kernel
booti ${kernel_addr_r} - ${fdt_addr_r}
