{
  description = "Henry's Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations.henry-linux =
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [
          # Base HM settings for this user
          {
            home.username = "henry";
            home.homeDirectory = "/home/henry";
            home.stateVersion = "25.05";

            nixpkgs.config.allowUnfree = true;
          }

          # Your modules
          ./home/common.nix
          ./home/linux.nix
          ./home/gaming.nix
        ];
      };
  };
}
