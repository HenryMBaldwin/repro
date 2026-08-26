{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    AI_BRANCH_PREFIX = "hbai";
    CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS = "1";
  };

  # Land in the most recent tmux session on ssh login, or start one
  programs.zsh.initContent = lib.mkAfter ''
    if [[ -o interactive ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]] && command -v tmux &>/dev/null; then
        if tmux ls &>/dev/null; then
            exec tmux attach
        else
            exec tmux new-session
        fi
    fi
  '';

  programs.git.settings.user.name = lib.mkForce "henry-ai";
  programs.git.settings.user.email = lib.mkForce "henrymbaldwin+ai@proton.me";

  home.packages = [ pkgs.tailscale ];

  systemd.user.startServices = "sd-switch";
  systemd.user.services.tailscaled = {
    Unit.Description = "tailscaled (rootless, userspace networking)";
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/state/tailscale";
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.tailscale}/bin/tailscaled"
        "--tun=userspace-networking"
        "--state=%h/.local/state/tailscale/tailscaled.state"
        "--socket=%h/.local/state/tailscale/tailscaled.sock"
      ];
      Restart = "on-failure";
    };
  };

  programs.zsh.shellAliases.tailscale =
    "tailscale --socket=$HOME/.local/state/tailscale/tailscaled.sock";

  my.claudeRules = lib.mkAfter [
    ''
      All git branches must be prefixed with `$AI_BRANCH_PREFIX__` (default: `cdai__`). For example: `cdai__fix-login-bug`, `cdai__add-feature`. Never push to any branch without this prefix. Deleting local branches is fine, but never push-delete remote branches without this prefix.
    ''
  ];
}
