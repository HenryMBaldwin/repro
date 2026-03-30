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
            # ENV

			export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.zplug/bin:$HOME/google-cloud-sdk/bin:$PATH:$HOME/.seismic/bin"

            # gh cli 
            export GH_EDITOR="nvim"

            # BINDINGS

            # Arrow keys in insert mode
            bindkey -M viins "$terminfo[kcuu1]" history-beginning-search-backward
            bindkey -M viins "$terminfo[kcud1]" history-beginning-search-forward

            # j/k in normal mode
            bindkey -M vicmd 'k' history-beginning-search-backward
            bindkey -M vicmd 'j' history-beginning-search-forward

            # FUNCTIONS 
            
            # output the current git branch name
            function gbc() {
                git branch --show-current
            }

            # get the hash of the latest commit
            function glch() {
                git log -1 --pretty=format:%H | cat
            }

            # copy the output of a command to the clipboard and print it
            function copy() {
                "$@" | tee >(pbcopy)
            }

            # zsh-vi-mode config (called automatically by by zsh-vi-mode)
            function zvm_config() {
                ZVM_SYSTEM_CLIPBOARD_ENABLED=true
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
