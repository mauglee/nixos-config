{ config, pkgs, identity, systemSettings, ... }:

let
  cleanup = pkgs.writeShellScriptBin "cleanup" ''
  read -p "All other generations will be deleted. Continue? [Y/n]" -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
  fi
  
  sudo nix-collect-garbage -d
  sudo /run/current-system/bin/switch-to-configuration boot
  echo "Should be clean now" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
  '';
  phpStormWithPlugins = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm [
    "symfony-support"
    "php-annotations"
    "nixidea"
  ];
in
{
  home = {
    username = identity.username;
    homeDirectory = identity.homeDirectory;
    keyboard = null; # managed in configuration.nix
    packages = with pkgs; [
      # non-GUI
      bat bruno btop cleanup git file lsd neofetch nerdfonts tree wl-clipboard
      pkgs.${systemSettings.defaultEditor}
      ripgrep zip unzip

      # GUI
      brave gnome.dconf-editor gnome.gnome-session
      gnomeExtensions.appindicator # also is enabled in dconf settings bellow
      libreoffice
      litemdview # Suckless markdown viewer
      phpStormWithPlugins
      sqlitebrowser telegram-desktop tor-browser
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
        lmd = "litemdview -t 1";
        m = "micro";
        rebuild = "sudo nixos-rebuild switch --flake .";
        gs = "git status";
        gc = "git commit -a";
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
      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = false;
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };
      "org/gnome/desktop/search-providers" = {
        disabled = [ "org.gnome.Contacts.desktop" "org.gnome.Characters.desktop" ];
      };
      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
      };
      "org/gnome/nautilus/list-view" = {
        default-zoom-level = "small";
      };
      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        search-filter-time-type = "last_modified";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Power off";
        command = "gnome-session-quit --power-off";
        binding = "<Super>x";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Console";
        command = "kgx";
        binding = "<Control><Alt>t";
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-battery-type = "nothing";
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
