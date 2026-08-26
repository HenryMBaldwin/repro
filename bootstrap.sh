#!/usr/bin/env bash
#
# Bootstrap this machine from a fresh clone.
#
#   ./bootstrap.sh <profile>
#
# where <profile> is one of the configurations defined in flake.nix:
#
#   mac            # aarch64-darwin (nix-darwin + Home Manager + Homebrew casks)
#   linux          # x86_64-linux
#   linux-server   # x86_64-linux + server extras
#
# It installs Nix (Determinate installer) if missing, then applies the chosen
# configuration. On mac, nix-homebrew installs/adopts Homebrew during
# activation, so brew doesn't need to be present beforehand.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

NIX_DARWIN_REF="github:nix-darwin/nix-darwin/nix-darwin-25.11"
FLAKE_FEATURES='nix-command flakes'

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m error:\033[0m %s\n' "$*" >&2; exit 1; }

# --- Profile must be passed explicitly -----------------------------------
VALID_PROFILES="mac linux linux-server"

if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
  die "no profile given. Usage: ./bootstrap.sh <profile>  (one of: $VALID_PROFILES)"
fi

PROFILE="$1"

case " $VALID_PROFILES " in
  *" $PROFILE "*) ;;
  *) die "unknown profile '$PROFILE'. Choose one of: $VALID_PROFILES" ;;
esac

log "Using profile: .#$PROFILE"

# --- Ensure Nix is installed ---------------------------------------------
ensure_nix() {
  # Source the daemon profile if a prior install left it on disk but not on PATH.
  if ! command -v nix >/dev/null 2>&1; then
    for p in \
      /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
      "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
      [ -e "$p" ] && . "$p"
    done
  fi

  if command -v nix >/dev/null 2>&1; then
    log "Nix already installed: $(nix --version)"
    return
  fi

  log "Nix not found — installing via the Determinate Systems installer"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install

  for p in \
    /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
    "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
    [ -e "$p" ] && . "$p"
  done

  command -v nix >/dev/null 2>&1 \
    || die "Nix installed but not on PATH. Open a new terminal and re-run ./bootstrap.sh $PROFILE"
}

ensure_nix

# --- Make zsh the login shell (home-manager can't do this itself) --------
# SSH sessions use the login shell from passwd; if it isn't zsh, ~/.zshrc
# never loads over ssh. Only acts when the current shell isn't already zsh.
ensure_zsh_login_shell() {
  local user current zsh_path
  user="$(id -un)"

  current="$(getent passwd "$user" 2>/dev/null | cut -d: -f7)"
  [ -n "$current" ] || current="$(dscl . -read "/Users/$user" UserShell 2>/dev/null | awk '{print $2}')"

  case "$current" in
    */zsh) return ;;
  esac

  if [ -x "$HOME/.nix-profile/bin/zsh" ]; then
    zsh_path="$HOME/.nix-profile/bin/zsh"
  else
    zsh_path="$(command -v zsh || true)"
  fi
  [ -n "$zsh_path" ] || { log "zsh not found; leaving login shell as '${current:-unknown}'"; return; }

  log "Changing login shell to zsh: '${current:-unknown}' -> '$zsh_path'"
  if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$zsh_path" \
    || sudo chsh -s "$zsh_path" "$user" \
    || log "warning: could not change login shell; run manually: chsh -s $zsh_path"
}

# --- Enable linger so user services (e.g. tailscaled) run without a login -
ensure_linger() {
  command -v loginctl >/dev/null 2>&1 || return
  local user; user="$(id -un)"
  [ "$(loginctl show-user "$user" -p Linger --value 2>/dev/null)" = "yes" ] && return
  log "Enabling linger for $user (user services run without an active login)"
  sudo loginctl enable-linger "$user" \
    || log "warning: could not enable linger; run manually: sudo loginctl enable-linger $user"
}

# --- Apply the configuration ---------------------------------------------
if [ "$PROFILE" = "mac" ]; then
  log "Applying nix-darwin configuration (.#mac)"
  if command -v darwin-rebuild >/dev/null 2>&1; then
    # --impure lets the flake read $SUDO_USER/$USER to detect the account name.
    sudo darwin-rebuild switch --flake ".#mac" --impure
  else
    # First run: darwin-rebuild isn't installed yet, so pull it from the flake.
    sudo nix run \
      --extra-experimental-features "$FLAKE_FEATURES" \
      "$NIX_DARWIN_REF#darwin-rebuild" -- switch --flake ".#mac" --impure
  fi
else
  log "Applying Home Manager configuration (.#$PROFILE)"
  # --impure lets the flake read $USER to detect the account name.
  nix run \
    --extra-experimental-features "$FLAKE_FEATURES" \
    home-manager -- switch -b hm-bak --flake ".#$PROFILE" --impure
fi

ensure_zsh_login_shell
ensure_linger

log "Done. Restart your shell (or run: exec \$SHELL -l) to pick up the new environment."
