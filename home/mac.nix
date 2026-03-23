{ config, pkgs, ... }:

{
  home.file."Library/Application Support/Rectangle/RectangleConfig.json".source =
    ../config/rectangle/RectangleConfig.json;
}
