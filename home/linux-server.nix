{ config, pkgs, lib, ... }:

let
  githubUser = "HenryMBaldwin";
  githubAuthorizedKeys = pkgs.writeShellApplication {
    name = "github-authorized-keys";
    runtimeInputs = with pkgs; [ curl gawk coreutils ];
    text = builtins.readFile ../scripts/github-authorized-keys.sh;
  };
in
{
  home.sessionVariables = {
    AI_BRANCH_PREFIX = "hbai";
    CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS = "1";
  };

  programs.zsh.initContent = lib.mkAfter (builtins.readFile ../config/zsh/tmux-attach.zsh);

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

  home.activation.githubAuthorizedKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${githubAuthorizedKeys}/bin/github-authorized-keys ${githubUser}
  '';

  my.claudeRules = lib.mkAfter [
    ''
      All git branches must be prefixed with `$AI_BRANCH_PREFIX__` (default: `cdai__`). For example: `cdai__fix-login-bug`, `cdai__add-feature`. Never push to any branch without this prefix. Deleting local branches is fine, but never push-delete remote branches without this prefix.
    ''
  ];
}
