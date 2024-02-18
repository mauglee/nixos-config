{ config, pkgs, identity, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

    # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Desktop Environment
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # keyboard
    layout = "lt,ru";
    xkbVariant = ",phonetic";
    xkbOptions = "grp:win_space_toggle";
  };

  # exclude some default packages from Gnome
  environment.gnome.excludePackages = with pkgs; [
    gnome.geary epiphany xterm
  ];

  # Configure console keymap
  console.keyMap = "lt.baltic";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${identity.username} = {
    isNormalUser = true;
    description = identity.fullName;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # nothing here: packages are managed by home-manager
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # system-wide packages
  environment.systemPackages = with pkgs; [
    #vim
  ];

  # List services that you want to enable:
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "never"; # run `sudo updatedb` manually
    localuser = null; # mlocate and plocate do not support the services.locate.localuser option. updatedb will run as root
  };

  services.logind.lidSwitch = "ignore";

  # Better scheduling for CPU cycles - thanks System76!!!
  services.system76-scheduler.settings.cfsProfiles.enable = true;

  # Enable TLP (better than gnomes internal power manager)
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  # agenix
  age.secrets.foo.file = ./secrets.foo.age;

  # Disable GNOMEs power management
  services.power-profiles-daemon.enable = false;

  # Enable powertop
  powerManagement.powertop.enable = true;

  # Enable thermald (only necessary if on Intel CPUs)
  services.thermald.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
