{
  description = "NixOS based netboot micro cluster, based on RPi Zero 2 W and RPi 4 devices";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    uboot-builder.url = "github:denver-cfman/nixos-netboot-cluster-uboot";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, uboot-builder, disko, sops-nix, home-manager }: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      # Import your new file
      builder = import ./modules/netboot-builder.nix { inherit pkgs; };
    in {
      firmware-rpi4 = builder.mkNetbootFirmware { 
        uboot = pkgs.ubootRaspberryPi4_64bit; # Example usage
        configTxt = "kernel=kernel.img"; 
        bootCmd = ./boot.cmd; 
      };
    };
    nixosConfigurations = {
      lab3netbootserver = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self uboot-builder; packages = self.packages.x86_64-linux; };
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/Lab3NetBootServer.nix
          ./modules/netboot-infrastructure.nix
        ];
      };
      pi-client-01 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self uboot-builder; packages = self.packages.x86_64-linux; };
        system = "aarch64-linux";
        modules = [
          ./hosts/pi-client-01.nix
          ./modules/netboot-client.nix
        ];
      };
    };
  };
}
