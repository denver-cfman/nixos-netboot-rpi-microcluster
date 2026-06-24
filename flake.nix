{
  description = "NixOS based netboot micro cluster, based on RPi Zero 2 W and RPi 4 devices";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    uboot-builder.url = "github:denver-cfman/nixos-netboot-cluster-uboot"; 
  };

  outputs = { self, nixpkgs, uboot-builder }: {
    nixosConfigurations = {
      netboot-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/netboot-server.nix
          ./modules/netboot-infrastructure.nix
        ];
      };
      pi-client-01 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/pi-client-01.nix ];
      };
    };
  };
}
