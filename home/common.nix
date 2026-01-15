{ config, pkgs, ... }:

{
  # Shared packages for every machine
  home.packages = with pkgs; [
    home-manager
  ];
}
