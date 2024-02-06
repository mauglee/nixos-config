# NixOS config

## Get project
```
cd ~/projects
git clone git@github.com:mauglee/nixos-config.git
cd nixos-config
```

## Update packages
`nix flake update`

## Rebuild
`sudo nixos-rebuild switch --flake .`

## Generate hardware configuration
`nixos-generate-config --show-hardware-config > hardware-configuration.nix`

## Other
### Generate config
`sudo nixos-generate-config` writes two NixOS configuration modules:
- `/etc/nixos/hardware-configuration.nix` – if this file already exists, it is *overwritten*
- `/etc/nixos/configuration.nix` – if it already exists, it’s left *unchanged*

## Scripts, aliases
`<Control>Print` starts `shutter` program (screenshot)
```
$ alias
alias ..='cd ..'
alias l='lsd'
alias la='lsd -lah'
alias ll='ls -l'
alias ls='ls --color=tty'
alias m='micro'
alias rebuild='sudo nixos-rebuild switch --flake .'
```
