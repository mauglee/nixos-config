{ config, pkgs, identity, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # hostname is used in another cofigurations
  networking.hostName = "probook";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "never"; # run `sudo updatedb` manually
    localuser = null; # mlocate and plocate do not support the services.locate.localuser option. updatedb will run as root
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
