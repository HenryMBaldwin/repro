{
  description = "Henry's Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Add this
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { nixpkgs, home-manager, claude-code, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        # Apply overlay so pkgs.claude-code comes from claude-code-nix
        overlays = [ claude-code.overlays.default ];
      };
    in {
      homeConfigurations.henry-linux =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home.username = "henry";
              home.homeDirectory = "/home/henry";
              home.stateVersion = "25.05";
            }

            ./home/common.nix
            ./home/dev.nix
            ./home/gaming.nix
            ./home/linux.nix
          ];
        };
    };
}
