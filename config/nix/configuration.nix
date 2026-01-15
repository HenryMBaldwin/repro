{ config, pkgs, ... }:

{
  ################################
  # Imports
  ################################
  imports = [
    ./hardware-configuration.nix
  ];

  ################################
  # Nix / flakes
  ################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  ################################
  # Bootloader
  ################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ################################
  # Networking
  ################################
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  ################################
  # Locale / timezone
  ################################
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  ################################
  # Desktop: GNOME on Wayland
  ################################
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Wayland (default for GDM)
  services.xserver.displayManager.gdm.wayland = true;

  services.xserver.xkb.layout = "us";

  ################################
  # Sound: PipeWire
  ################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ################################
  # Printing
  ################################
  services.printing.enable = true;

  ################################
  # Graphics (NVIDIA)
  ################################
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;  # <-- added for Steam/Proton 32-bit

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
  };

  ################################
  # Docker
  ################################
  virtualisation.docker.enable = true;

  ################################
  # Games
  ################################
  hardware.xpadneo.enable = true;
  #boot.blacklistedKernelModules = ["xpad"];

  ################################
  # Users
  ################################
  users.users.henry = {
    isNormalUser = true;
    description  = "Henry";
    extraGroups  = [ "networkmanager" "wheel" "docker" ];
    shell        = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.appimage.enable = true;


  ################################
  # System packages
  ################################
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    htop
    jq
    gnomeExtensions.tiling-assistant
  ];

  ################################
  # System state version
  ################################
  system.stateVersion = "25.05";
}

