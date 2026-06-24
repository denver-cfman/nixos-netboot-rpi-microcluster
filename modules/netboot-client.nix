# modules/netboot-client.nix
{ config, lib, ... }: {
  fileSystems."/" = {
    device = "192.168.1.5:/export/client-01";
    fsType = "nfs";
    options = [ "vers=4.2" "proto=tcp" "timeo=600" ];
  };
  
  # Ensure the kernel has NFS support built-in
  boot.initrd.supportedFilesystems = [ "nfs" ];
  boot.kernelParams = [ "nfsroot=192.168.1.5:/export/client-01" "ip=dhcp" ];
}
