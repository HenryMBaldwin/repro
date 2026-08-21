{ config, pkgs, ... }:

{
    imports = [ ./dev-config.nix ./claude.nix ];

    home.packages = with pkgs; [
        # CLI tools
		tmux
		neovim
		ripgrep
		tree-sitter
		gh
		just

		# Toolchains
		rustup
		go
		nodejs_24
		python3
		uv
		bun
		cmake

		# Python LSP/lint/format tooling for nvim
		ruff
		pyrefly
		basedpyright

		# Misc
		docker-client

	];
}
