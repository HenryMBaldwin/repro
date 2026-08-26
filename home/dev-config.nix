{ config, pkgs, lib, ... }:

{
    # CLI + tools

    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
    };

    home.sessionVariables = {
        CODE_PATH = "$HOME/dev";
        # nvim isn't on root's PATH; sudoedit runs the editor as you, writes as root.
        SUDO_EDITOR = "nvim";
    };

    programs.zsh = {
		enable = true;
		autosuggestion.enable = true;
        history.size = 100000;
        history.save = 100000;
        history.append = true;
        history.ignoreDups = false;


		zplug = {

		  enable = true;
		  plugins = [
			{ name = "jeffreytse/zsh-vi-mode"; }
			{ name = "zdharma-continuum/fast-syntax-highlighting"; }
			{ name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
			{ name = "plugins/direnv"; tags = [ from:oh-my-zsh ]; }
		  ];
		};


		shellAliases = {
			history = "history 1";
			# Drop the nix-darwin guard so /etc/zshenv rebuilds PATH, and direnv's
			# state so it reloads onto that fresh PATH instead of a stale diff.
			reloadz = "exec env -u __NIX_DARWIN_SET_ENVIRONMENT_DONE -u DIRENV_DIFF -u DIRENV_WATCHES -u DIRENV_DIR -u DIRENV_FILE zsh";
			ghard = "git reset --hard HEAD";
		};

        initContent = lib.mkMerge [
          (lib.mkBefore "zstyle ':omz:alpha:lib:git' async-prompt no")
          (builtins.readFile ../config/zsh/dev.zsh)
        ];

	};

    programs.git = {
        enable = true;
        settings.user.name = "Henry Baldwin";
        settings.user.email = "henrymbaldwin@proton.me";
    };

	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};

    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };

	# Dotfiles and config
	home.file.".tmux.conf".source =
	../config/tmux/.tmux.conf;

	home.file.".config/ghostty/config".source =
	../config/ghostty/config;

	home.file.".config/starship.toml".source =
	../config/starship/starship.toml;

	home.file.".config/nvim".source =
    ../config/nvim;

}
