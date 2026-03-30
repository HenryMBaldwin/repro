{
  description = "Henry's Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Add this
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { nixpkgs, home-manager, claude-code, ... }:
    let
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;

        # Apply overlay so pkgs.claude-code comes from claude-code-nix
        overlays = [ claude-code.overlays.default ];
      };

      macPkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    in {
      homeConfigurations.henry-linux =
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

      homeConfigurations.henry-mac =
        home-manager.lib.homeManagerConfiguration {
          pkgs = macPkgs;

          modules = [
            {
              home.username = "henrybaldwin";
              home.homeDirectory = "/Users/henrybaldwin";
              home.stateVersion = "25.05";
            }

            ./home/common.nix
            ./home/dev.nix
            ./home/mac.nix
          ];
        };
    };
}
