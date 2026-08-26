{ config, pkgs, lib, ... }:

{
    imports = [ ./dev-config.nix ./claude.nix ./agent-notify.nix ];

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

	] ++ lib.optionals pkgs.stdenv.isLinux [ tailscale ];
}
