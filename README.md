# repro

Reproducible development environment managed with [Nix Home Manager](https://github.com/nix-community/home-manager), plus [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) on macOS for system settings and declarative Homebrew casks (Homebrew itself is installed and pinned by the flake).

## What's included

- **Shell**: zsh with vi-mode, syntax highlighting, starship prompt, zoxide
- **Dev tools**: neovim, tmux, ripgrep, gh
- **Toolchains**: Rust, Go, Node.js, Python/uv, Bun
- **Configs**: ghostty, starship, nvim, tmux, hammerspoon, rectangle
- **macOS apps** (via Homebrew casks, managed by nix-darwin): Docker Desktop, Tailscale, Rectangle, Flycut, Karabiner-Elements, Hammerspoon, Bitwarden, Codex, Ghostty, LibreWolf, Fira Code

## Prerequisites

Install Nix with flakes enabled. The [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) is the easiest way:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Bootstrap

Clone the repo and run the bootstrap script with your profile. It installs Nix
(if missing), installs Homebrew on macOS (if missing), and applies the
configuration in one step:

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

- `mac` — macOS (Apple Silicon), via nix-darwin (Home Manager + Homebrew casks)
- `linux` — Linux (x86_64), standalone Home Manager
- `linux-devbox` — Linux (x86_64) with devbox extras

On the first mac run, `darwin-rebuild` isn't installed yet, so the script pulls
it from the flake and asks for `sudo` (nix-darwin activates system-level
settings). Some casks — Karabiner-Elements, Docker Desktop, Tailscale — install
system extensions or drivers and will prompt for approval in **System Settings →
Privacy & Security** the first time.

## Updating

After editing any `.nix` file or config, re-apply:

```sh
make switch PROFILE=mac        # or: linux, linux-devbox
```

Doing it by hand:

```sh
sudo darwin-rebuild switch --flake .#mac         # macOS
nix run home-manager -- switch --flake .#linux   # Linux
```

To manage macOS apps, edit the `casks` list in `darwin/mac.nix` and re-run the
switch. To update flake inputs (nixpkgs, home-manager, nix-darwin, ...):

```sh
nix flake update
```
