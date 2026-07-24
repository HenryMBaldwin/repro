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

Clone the repo and run the bootstrap script with your profile. It installs Nix
(if missing) and applies the Home Manager configuration in one step:

```sh
git clone https://github.com/henrymbaldwin/repro.git
cd repro
./bootstrap.sh mac            # or: linux, linux-devbox
```

Or via make:

```sh
make bootstrap PROFILE=mac    # or: linux, linux-devbox
```

Profiles map to the configurations in `flake.nix`:

- `mac` — macOS (Apple Silicon)
- `linux` — Linux (x86_64)
- `linux-devbox` — Linux (x86_64) with devbox extras

If you'd rather do it by hand (Nix already installed):

```sh
nix run home-manager -- switch --flake .#mac   # or: linux, linux-devbox
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
