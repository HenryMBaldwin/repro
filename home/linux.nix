{ config, pkgs, ... }:

{
  # Enable generic Linux desktop integration (for non-NixOS)
  targets.genericLinux.enable = true;

  # Enable XDG integration for desktop files
  xdg.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
  ];

  # GNOME-only tweaks
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/henry/Pictures/wallpaper.jpg";
      picture-options = "zoom";
    };
  };

}
