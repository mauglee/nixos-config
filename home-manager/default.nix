{ config, pkgs, identity, systemSettings, ... }:

let
  cleanup = pkgs.writeShellScriptBin "cleanup" ''
  read -p "All other generations will be deleted. Continue? [Y/n]" -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
  fi
  
  sudo /run/current-system/bin/switch-to-configuration boot
  sudo nix-collect-garbage -d
  echo "Should be clean now" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
  '';
in
{
  home = {
    username = identity.username;
    homeDirectory = identity.homeDirectory;
    keyboard = null; # managed in configuration.nix
    packages = with pkgs; [
      # non-GUI
      bat btop cleanup git file lsd neofetch nerdfonts tree wl-clipboard
      pkgs.${systemSettings.defaultEditor}
      ripgrep zip unzip

      # GUI
      brave gnome.dconf-editor
      gnomeExtensions.appindicator # also is enabled in dconf settings bellow
      (jetbrains.plugins.addPlugins jetbrains.phpstorm [ "symfony-support" "php-annotations" "nixidea" ]) # this installs jetbrains.phpstorm with plugins
      libreoffice telegram-desktop
      meld # visual diff and merge tool
      yt-dlp
    ];
    
    # Example of dotfile
    #file.".config/foo/bar.conf".source = ./foo.conf;

    stateVersion = "23.11";
  };
  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      shellAliases = {
        ".." = "cd ..";
        l = "lsd";
        la = "lsd -lah";
        m = "micro";
        rebuild = "sudo nixos-rebuild switch --flake .";
      };
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "TTY";
        proc_sorting = "memory";
      };
    };
    git = {
      enable = true;
      userName = "Maug Lee";
      userEmail = "mauglee@gmail.com";
      extraConfig = {
        pull.rebase = false;

        merge.tool = "meld";
        mergetool.meld = {
          cmd = "meld $LOCAL $REMOTE $BASE $MERGED";
          path = "${pkgs.meld}/bin/meld";
          trustExitCode = true;
          hasOutput = true; # tells Git to skip checking whether meld supports --output (older versions of meld do not support)
        };
        mergetool.prompt = false;
        mergetool.keepBackup = false;
        
        diff.tool = "meld";
        difftool.meld = {
          cmd = "meld $LOCAL $REMOTE";
          path = "${pkgs.meld}/bin/meld";
          trustExitCode = true;
        };
        difftool.prompt = false;
      };
    };
    micro = {
      enable = true;
      settings = {
        autosu = true;
        colorscheme = "simple";
        filetype = "nix";
        hlsearch = true;
        mkparents = true;
        tabtospaces = true;
        tabsize = 2;
        tabmovement = true;
      };
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Console";
        command = "kgx";
        binding = "<Control><Alt>t";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        disabled-extensions = [
          "light-style@gnome-shell-extensions.gcampax.github.com"
          "native-window-placement@gnome-shell-extensions.gcampax.github.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "window-list@gnome-shell-extensions.gcampax.github.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        ];
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "places-menu@gnome-shell-extensions.gcampax.github.com"
        ];
      };
    };
  };
}
