{ pkgs, username, ... }:

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

      # nixpkgs' warpd is linux-only; upstream ships a universal darwin binary.
      warpd = prev.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "warpd";
        version = "1.3.5";

        src = prev.fetchurl {
          url = "https://github.com/rvaiya/warpd/releases/download/v${finalAttrs.version}/warpd-${finalAttrs.version}-osx.tar.gz";
          hash = "sha256-Sku66zqGTNRbPTvYQb3YfcZ7IJm4YNoYuB77I9KK+ys=";
        };

        sourceRoot = ".";

        installPhase = ''
          runHook preInstall
          install -Dm755 usr/local/bin/warpd $out/bin/warpd
          install -Dm644 usr/local/share/man/man1/warpd.1.gz $out/share/man/man1/warpd.1.gz
          runHook postInstall
        '';

        meta = {
          description = "Modal keyboard-driven pointer manipulation";
          homepage = "https://github.com/rvaiya/warpd";
          license = prev.lib.licenses.mit;
          platforms = prev.lib.platforms.darwin;
          mainProgram = "warpd";
        };
      });
    })
  ];

  system.stateVersion = 5;
  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

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
