{ config, pkgs, ... }:

{
    imports = [ ./dev-config.nix ];

    home.packages = with pkgs; [
        # CLI tools
		tmux
		neovim
		ghostty
        claude-code

		# Toolchains
		rustup
		go
		nodejs_24
		python3

		# Misc
		docker-client
	];
}
