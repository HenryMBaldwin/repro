{ config, pkgs, ... }:

{
  # nix-darwin runs the activation under `sudo -u`, which drops nix from PATH;
  # without this the final `nix-store --add-root` step exits 127.
  home.extraActivationPath = [ pkgs.nix ];

  home.file."Library/Application Support/Rectangle/RectangleConfig.json".source =
    ../config/rectangle/RectangleConfig.json;

  home.file.".hammerspoon/init.lua".source =
    ../config/hammerspoon/init.lua;
}
