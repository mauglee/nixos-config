# NixOS config
Some usage memo

## Generate config
`sudo nixos-generate-config` writes two NixOS configuration modules:
- `/etc/nixos/hardware-configuration.nix` – if this file already exists, it is *overwritten*
- `/etc/nixos/configuration.nix` – if it already exists, it’s left *unchanged*
