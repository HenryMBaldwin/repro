{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    AI_BRANCH_PREFIX = "hbai";
    CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS = "1";
  };

  programs.git.settings.user.name = lib.mkForce "henry-ai";
  programs.git.settings.user.email = lib.mkForce "henrymbaldwin+ai@proton.me";

  my.claudeRules = lib.mkAfter [
    ''
      All git branches must be prefixed with `$AI_BRANCH_PREFIX__` (default: `cdai__`). For example: `cdai__fix-login-bug`, `cdai__add-feature`. Never push to any branch without this prefix. Deleting local branches is fine, but never push-delete remote branches without this prefix.
    ''
  ];
}
