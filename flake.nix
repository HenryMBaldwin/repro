{
  description = "Henry's Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Pinned Homebrew taps so cask/formula definitions are locked too.
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };

    # Add this
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { nixpkgs, home-manager, nix-darwin, nix-homebrew, homebrew-core, homebrew-cask, claude-code, ... }:
    let
      # Detect the invoking user so the same config works on every machine
      # (macs, linux servers) with no hardcoded name. Requires --impure, since
      # builtins.getEnv only reads the environment in impure eval. Under `sudo`
      # (the mac rebuild) $USER is "root", so prefer $SUDO_USER and fall back
      # to $USER for the un-sudo'd linux home-manager runs.
      username =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          envUser  = builtins.getEnv "USER";
        in
          if sudoUser != "" then sudoUser
          else if envUser != "" then envUser
          else throw "Could not detect a username from $SUDO_USER or $USER. Build with --impure (see README).";

      # Follow the host arch so the same profile works on x86_64 and aarch64.
      linuxPkgs = import nixpkgs {
        system = builtins.currentSystem;
        config.allowUnfree = true;

        # Apply overlay so pkgs.claude-code comes from claude-code-nix
        overlays = [ claude-code.overlays.default ];
      };

      mkLinux = extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;
          modules = [
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
              home.stateVersion = "25.05";
            }
            ./home/common.nix
            ./home/dev.nix
          ] ++ extraModules;
        };
    in {
      homeConfigurations.linux = mkLinux [ ./home/desktop.nix ];

      homeConfigurations.linux-server = mkLinux [ ./home/linux-server.nix ];

      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit username; };
        modules = [
          ./darwin/mac.nix

          { nixpkgs.overlays = [ claude-code.overlays.default ]; }

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = username;
              autoMigrate = true;
              mutableTaps = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
            };
          }

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.users.${username} = {
              imports = [ ./home/common.nix ./home/dev.nix ./home/mac.nix ./home/desktop.nix ];
              home.username = username;
              home.homeDirectory = "/Users/${username}";
              home.stateVersion = "25.05";
            };
          }
        ];
      };
    };
}
