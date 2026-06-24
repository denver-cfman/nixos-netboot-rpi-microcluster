{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    uboot-builder.url = "github:denver-cfman/nixos-netboot-cluster-uboot"; 
  };

  outputs = { self, nixpkgs, uboot-builder }: {
    nixosConfigurations = {
      # The Netboot Server
      netboot-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/netboot-server.nix
          ./modules/netboot-infrastructure.nix
        ];
      };
      
      # The First Client
      pi-client-01 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/pi-client-01.nix ];
      };
    };
  };
}
