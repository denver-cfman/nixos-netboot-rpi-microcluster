{ config, pkgs, ... }:

{
  imports = [
    ./uefi_disko.nix
    ../modules/netboot-infrastructure.nix
  ];

  cluster.netboot.rootDir = "/export";

  systemd.tmpfiles.rules = [
    "d /var/lib/tftpboot 0755 root root -"
    "d /export 0755 root root -"
    "d /export/pi-client-01 0755 root root -"
  ];
}
