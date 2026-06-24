#    nixos-netboot-rpi-microcluster

---
## valadate flake
```bash
nix flake check -v -L --no-build --no-write-lock-file --all-systems --refresh github:denver-cfman/nixos-netboot-rpi-microcluster?ref=main
```


## Build the Netboot Server
```bash
nix run github:nix-community/nixos-anywhere -- --flake 'github:denver-cfman/nixos-netboot-rpi-microcluster?ref=main#lab3netbootserver' --target-host nixos@10.0.83.20
```
