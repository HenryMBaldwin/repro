{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
    # CLI tools
		tmux
		neovim
		ghostty
		git

		# Toolchains
		rustup
		go
		nodejs_20
		python3

		# Misc
		docker-client
	];

    # CLI + tools

    programs.zsh = {
		enable = true;
		history.size = 10000;
		autosuggestion.enable = true;
		historySubstringSearch.enable = true;

		zplug = {
		  enable = true;
		  plugins = [
			{ name = "jeffreytse/zsh-vi-mode"; }
			{ name = "zdharma-continuum/fast-syntax-highlighting"; }
			{ name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
			{ name = "zsh-users/zsh-history-substring-search"; }
			# { name = "plugins/direnv", from:oh-my-zsh;}
		  ];
		};


		shellAliases = {
			reloadz = "exec zsh";
			ghard = "hit reset --hard HEAD";
		};
        initExtra = ''
            # history substring search bindings
            bindkey '^[[A' history-substring-search-up
            bindkey '^[[B' history-substring-search-down

            # vi mode keymaps
            bindkey -M viins '^[[A' history-substring-search-up
            bindkey -M viins '^[[B' history-substring-search-down

            bindkey -M vicmd 'k' history-substring-search-up
            bindkey -M vicmd 'j' history-substring-search-down
        '';

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
	
