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
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;

        # Apply overlay so pkgs.claude-code comes from claude-code-nix
        overlays = [ claude-code.overlays.default ];
      };
    in {
      homeConfigurations.linux =
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [
            {
              home.username = "henry";
              home.homeDirectory = "/home/henry";
              home.stateVersion = "25.05";
            }

            ./home/common.nix
            ./home/dev.nix
          ];
        };

      homeConfigurations.linux-devbox =
        home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [
            {
              home.username = "henry";
              home.homeDirectory = "/home/henry";
              home.stateVersion = "25.05";
            }

            ./home/common.nix
            ./home/dev.nix
            ./home/linux-devbox.nix
          ];
        };

      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/mac.nix

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "henrybaldwin";
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
            home-manager.users.henrybaldwin = {
              imports = [ ./home/common.nix ./home/dev.nix ./home/mac.nix ];
              home.username = "henrybaldwin";
              home.homeDirectory = "/Users/henrybaldwin";
              home.stateVersion = "25.05";
            };
          }
        ];
      };
    };
}
