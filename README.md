# NixOS config

```
sudo nano /etx/nixos/configuration.nix
```
Add `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
Add `git` to packages
Set `networking.hostName = "probook";`
```
sudo nixos-rebuild switch
```
Log-out and log-in to observe new hostname

## Get project
```
cd ~/projects
git clone git@github.com:mauglee/nixos-config.git
cd nixos-config
cp /etc/nixos/hardware-configuration.nix .
```

## Update packages
`nix flake update`

## Rebuild
`sudo nixos-rebuild switch --flake .`

## Generate hardware configuration
`nixos-generate-config --show-hardware-config > hardware-configuration.nix`

## Shortcuts
* `<Control>Print` screenshot program [not set at the moment]
* `<Control><Alt>t` console `kgx`

## Scripts (only essential parts shown)
```
$ bat `which cleanup`
sudo /run/current-system/bin/switch-to-configuration boot
sudo nix-collect-garbage -d
```

## Aliases
```
alias ..='cd ..'
alias l='lsd'
alias la='lsd -lah'
alias ll='ls -l'
alias lmd='litemdview -t 1'
alias ls='ls --color=tty'
alias m='micro'
alias rebuild='sudo nixos-rebuild switch --flake .'
```

## Other
### Generate config
`sudo nixos-generate-config` writes two NixOS configuration modules:
- `/etc/nixos/hardware-configuration.nix` – if this file already exists, it is *overwritten*
- `/etc/nixos/configuration.nix` – if it already exists, it’s left *unchanged*

### Markdown
`.md` file view'er is `litemdview`

### Git
Merge and diff tool is `meld`
