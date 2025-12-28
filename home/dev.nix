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
        history.save = 100000;
        history.append = true;


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
			reloadz = "exec zsh";
			ghard = "hit reset --hard HEAD";
		};

        initContent = ''
            # Arrow keys in insert mode
            bindkey -M viins "$terminfo[kcuu1]" history-search-backward
            bindkey -M viins "$terminfo[kcud1]" history-search-forward

            # j/k in normal mode
            bindkey -M vicmd 'k' history-search-backward
            bindkey -M vicmd 'j' history-search-forward
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
	
