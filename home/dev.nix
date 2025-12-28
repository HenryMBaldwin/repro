{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        # CLI tools
		tmux
		neovim
		ghostty
		git
		zoxide

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
	};

	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};
	
	# Dotfiles
	  home.file.".tmux.conf".source =
	    ../config/tmux/.tmux.conf;

	  home.file.".config/ghostty/config".source =
	    ../config/ghostty/config;

	  home.file.".config/starship.toml".source =
	    ../config/starship/starship.toml;

}
	
