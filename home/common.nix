{ config, pkgs, ... }:

{
  # Shared packages for every machine
  home.packages = with pkgs; [
    home-manager

    # GUI apps
    librewolf
    bitwarden
    spotify
    telegram-desktop
    discord
  ];


  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
}
