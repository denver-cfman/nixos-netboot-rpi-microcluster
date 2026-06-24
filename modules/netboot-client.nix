{ config, lib, ... }: {
  # This makes the client look for the NFS root
  boot.initrd.supportedFilesystems = [ "nfs" ];
  boot.kernelParams = [ 
    "ip=dhcp" 
    "nfsroot=192.168.1.5:/export/pi-client-01,vers=4.2,proto=tcp" 
  ];

  fileSystems."/" = {
    device = "192.168.1.5:/export/pi-client-01";
    fsType = "nfs";
    options = [ "vers=4.2" "proto=tcp" ];
  };
}
