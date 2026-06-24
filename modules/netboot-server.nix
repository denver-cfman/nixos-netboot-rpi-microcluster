# modules/netboot-server.nix
{ config, pkgs, ... }: {
  services.dnsmasq = {
    enable = true;
    extraConfig = ''
      # Match PI by MAC to specific PXE configuration
      dhcp-host=dc:a6:32:xx:xx:xx,192.168.1.10,client-01
      enable-tftp
      tftp-root=/var/lib/tftpboot
      pxe-service=0,"Raspberry Pi",boot.scr
    '';
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export/client-01 192.168.1.10(rw,no_root_squash,no_subtree_check,sync)
    '';
  };
}
