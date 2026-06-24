{ pkgs, ... }: {
  mkNetbootFirmware = { uboot, configTxt, bootCmd }: pkgs.stdenv.mkDerivation {
    name = "rpi-netboot-${uboot.name}";
    nativeBuildInputs = [ pkgs.ubootTools ];
    BOOT_CMD = bootCmd;
    buildCommand = ''
      mkdir -p $out
      ${pkgs.ubootTools}/bin/mkimage -A arm -O linux -T script -C none -n "Boot Script" -d $BOOT_CMD $out/boot.scr
      cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/{bootcode.bin,start.elf,fixup.dat,*.dtb} $out/
      cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays $out/
      cp ${uboot}/u-boot.bin $out/kernel.img
      echo "${configTxt}" > $out/config.txt
    '';
  };
}
