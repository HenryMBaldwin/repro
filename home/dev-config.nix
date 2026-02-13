{ config, pkgs, ... }:

{
    # CLI + tools

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
			# { name = "plugins/direnv", from:oh-my-zsh;}
		  ];
		};


		shellAliases = {
			history = "history 1";
			reloadz = "exec zsh";
			ghard = "git reset --hard HEAD";
		};

        initContent = ''
			export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.zplug/bin:$PATH:$HOME/.seismic/bin"

            # Arrow keys in insert mode
            bindkey -M viins "$terminfo[kcuu1]" history-search-backward
            bindkey -M viins "$terminfo[kcud1]" history-search-forward

            # j/k in normal mode
            bindkey -M vicmd 'k' history-search-backward
            bindkey -M vicmd 'j' history-search-forward

            # get the hash of the latest commit
            function glch() {
                git log -1 --pretty=format:%H | cat
            }

            # copy the output of a command to the clipboard and print it
            function copy() {
                "$@" | tee >(pbcopy)
            }
        '';

	};

    programs.git = {
        enable = true;
        userName = "Henry Baldwin";
        userEmail = "henrymbaldwin@proton.me";
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
