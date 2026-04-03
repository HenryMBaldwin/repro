{ config, pkgs, ... }:

{
    imports = [ ./dev-config.nix ];

    home.packages = with pkgs; [
        # CLI tools
		tmux
		neovim

		# Toolchains
		rustup
		go
		nodejs_24
		python3
		uv

		# Misc
		docker-client
	];
}
