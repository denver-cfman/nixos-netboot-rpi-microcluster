{ config, pkgs, lib, self, ... }:

{
  imports = [
    ./uefi_disko.nix
    ../modules/netboot-infrastructure.nix
  ];

  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200n8"
    "quiet"
    "loglevel=3"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  
    # Enable Legacy GRUB
    grub = {
      enable = false;
      #device = "/dev/sda"; # The actual disk, NOT a partition
      #forceInstall = true;
      #useOSProber = false; # Set to true only if dual booting
    };
  };

  networking = {
    hostName = "Lab3NetBootServer";
    networkmanager = {
      enable = true;
    };
  };
  
  time.timeZone = "America/Denver";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.giezac = {
    isNormalUser = true;
    description = "giezac";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      oh-my-zsh 
    ];
    password = "changeme";
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZawwmpdesq0ZvtXTdPekpjK3OYiPONrKO0no625FqYG8A8fZY++cxjG4my6HgmoaBrZiWvRJTa0WfTfw9Tzx9xt/FKrCB4bk9G33WP+RJNF7AEo3wkGGBLHzxp9bnhzzxdJOQCV67DRDxQNjMiR5S/bkSU+QYPDq+MLLx8mFz8lfzOSThVgDLjOj7lsRAJcrFDawsjZYHjsVBdDfCkjXGPKT7/c90k0BOvOjnOZ4vEn1w2s/Neq0rDTJYDUSmu9SzW/+WkM1rZa4GS5QGFMJVrI1Ow3X8tiUYpAp1oa0MyIpRkpuP39W+I6qaRBW4/+lyJYWsLP09hU7K2wT6OGap forGitHub"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmNXnRi9A/6hQL0wxpyti2Qo+Sd8LZt0uLu/hSJ91tH root@R210ii"
  ];


  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    #virtualbox = {
    #  host = {
    #    enable = true;
    #    enableExtensionPack = true;
    #    addNetworkInterface = true;
    #    enableWebService = true;
    #    #package = "";
    #  };
    #};
  };

  services.qemuGuest.enable = true;
  systemd.services."serial-getty@ttyS0".enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    btop
    iftop
    curl
    git
    fastfetch
    jq
    podman
    podman-desktop
    podman-compose
    screen
  ];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "5min";
  };

  services.openssh.enable = true;

  system.stateVersion = "26.11";

  services.atftpd = {
    enable = true;
    root = "/var/lib/tftpboot";
    extraOptions = [ "--verbose" ];
  };

  system.activationScripts.deployNetbootFiles = {
      # Ensure this runs after the file systems are mounted
      deps = [ "users" ]; 
      text = ''
        echo "Deploying netboot files to /var/lib/tftpboot..."
        
        mkdir -p /var/lib/tftpboot/overlays
        
        cp ${self.packages.x86_64-linux.image-rpi4-5}/stage/* /var/lib/tftpboot/
        cp -r ${self.packages.x86_64-linux.image-rpi4-5}/stage/overlays/* /var/lib/tftpboot/overlays/
        
        chown -R atftpd:atftpd /var/lib/tftpboot
        chmod -R 755 /var/lib/tftpboot
      '';
    };

  cluster.netboot.rootDir = "/export";

  systemd.tmpfiles.rules = [
    "d /var/lib/tftpboot 0755 root root -"
    "d /export 0755 root root -"
    "d /export/pi-client-01 0755 root root -"
  ];
}
