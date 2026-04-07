# repro

Reproducible development environment managed with [Nix Home Manager](https://github.com/nix-community/home-manager).

## What's included

- **Shell**: zsh with vi-mode, syntax highlighting, starship prompt, zoxide
- **Dev tools**: neovim, tmux, ripgrep, gh
- **Toolchains**: Rust, Go, Node.js, Python/uv, Bun
- **Configs**: ghostty, starship, nvim, tmux, hammerspoon, rectangle

## Prerequisites

Install Nix with flakes enabled. The [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) is the easiest way:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Bootstrap

Clone the repo and apply the appropriate Home Manager configuration:

```sh
git clone https://github.com/henrymbaldwin/repro.git
cd repro
```

**macOS (Apple Silicon):**

```sh
nix run home-manager -- switch --flake .#mac
```

**Linux (x86_64):**

```sh
nix run home-manager -- switch --flake .#linux
```

## Updating

After making changes to any `.nix` files or configs, re-apply with the same switch command:

```sh
nix run home-manager -- switch --flake .#mac   # or linux
```

To update flake inputs (nixpkgs, home-manager, etc.):

```sh
nix flake update
```
