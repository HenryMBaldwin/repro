{ pkgs, ... }:

{
  # Determinate Nix manages the daemon; keep nix-darwin from fighting it.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      # direnv's fish test suite is SIGKILLed in the darwin sandbox.
      direnv = prev.direnv.overrideAttrs (old: {
        checkPhase = builtins.replaceStrings [ " test-fish" ] [ "" ] old.checkPhase;
      });
    })
  ];

  system.stateVersion = 5;
  system.primaryUser = "henrybaldwin";
  users.users.henrybaldwin.home = "/Users/henrybaldwin";

  homebrew = {
    enable = true;

    # cleanup = "none" leaves manually-installed casks alone.
    onActivation.cleanup = "none";
    onActivation.autoUpdate = false;
    onActivation.upgrade = false;

    casks = [
      # Dev / infra
      "docker-desktop"
      "tailscale-app"

      # Window & clipboard / automation
      "rectangle"
      "flycut"
      "karabiner-elements"
      "hammerspoon"

      # Apps
      "bitwarden"
      "codex"
      "ghostty"
      "librewolf"

      # Fonts
      "font-fira-code"
    ];
  };
}
