{ config, pkgs, ... }:

{
    imports = [ ./dev-config.nix ];

    home.packages = with pkgs; [
        # CLI tools
		tmux
		neovim
		ripgrep
		tree-sitter
		gh

		# Toolchains
		rustup
		go
		nodejs_24
		python3
		uv
		bun

		# Misc
		docker-client

	];
}
