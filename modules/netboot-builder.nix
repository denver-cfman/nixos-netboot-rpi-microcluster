{ pkgs, ... }: {
  mkNetbootFirmware = { uboot, configTxt, bootCmd }: pkgs.stdenv.mkDerivation {
    name = "rpi-netboot-${uboot.name}";
    # Use buildPackages to ensure the mkimage tool is runnable on your x86 server
    nativeBuildInputs = [ pkgs.buildPackages.ubootTools ];
    BOOT_CMD = bootCmd;
    buildCommand = ''
      mkdir -p $out
      # Use buildPackages to call the native binary
      ${pkgs.buildPackages.ubootTools}/bin/mkimage -A arm -O linux -T script -C none -n "Boot Script" -d $BOOT_CMD $out/boot.scr
      
      # The rest of your paths are fine as is
      cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/{bootcode.bin,start.elf,fixup.dat,*.dtb} $out/
      cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays $out/
      cp ${uboot}/u-boot.bin $out/kernel.img
      echo "${configTxt}" > $out/config.txt
    '';
  };
}
