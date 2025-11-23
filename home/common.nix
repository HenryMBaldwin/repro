{ config, pkgs, ... }:

{
  # Shared packages for every machine
  home.packages = with pkgs; [
    # CLI tools
    zsh
    tmux
    neovim
    ghostty
    git
    zoxide
    starship

    # Dev tools
    rustup
    go
    nodejs_20
    python3
    docker-client

    # GUI apps
    librewolf
    bitwarden
    spotify
    telegram-desktop
    discord
  ];

  # Dotfiles (shared)
  home.file.".zshrc".source = ../config/zsh/.zshrc;

  home.file.".config/tmux/tmux.conf".source =
    ../config/tmux/tmux.conf;

  home.file.".config/ghostty/config".source =
    ../config/ghostty/config;

  home.file.".config/starship.toml".source =
    ../config/starship/starship.toml;
}
