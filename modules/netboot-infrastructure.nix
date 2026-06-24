{ config, lib, pkgs, ... }:

{
  options.cluster.netboot = {
    rootDir = lib.mkOption { type = lib.types.str; default = "/export"; };
  };

  config = {
    # TFTP Service
    services.atftpd = {
      enable = true;
      root = "/var/lib/tftpboot";
    };

    # NFS Server
    services.nfs.server = {
      enable = true;
      exports = ''
        ${config.cluster.netboot.rootDir} 10.0.83.0/24(rw,no_root_squash,no_subtree_check,sync)
      '';
    };

    networking.firewall.allowedUDPPorts = [ 69 111 2049 ];
    networking.firewall.allowedTCPPorts = [ 111 2049 ];
  };
}
