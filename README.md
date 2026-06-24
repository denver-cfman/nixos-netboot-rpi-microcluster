#    nixos-netboot-rpi-microcluster

---

## Build the Netboot Server
```bash
nix run github:nix-community/nixos-anywhere -- --flake 'github:denver-cfman/nixos-netboot-rpi-microcluster?ref=master#lab3netbootserver' --target-host nixos@10.0.85.186
```
