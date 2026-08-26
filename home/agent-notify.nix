{ config, pkgs, lib, ... }:

let
  bell = "${config.home.homeDirectory}/.local/bin/agent-bell";
  hook = [ { hooks = [ { type = "command"; command = bell; } ]; } ];
  claudeHooks = builtins.toJSON { Notification = hook; Stop = hook; };
  agentBellHooks = pkgs.writeShellApplication {
    name = "agent-bell-hooks";
    runtimeInputs = with pkgs; [ jq python3 coreutils ];
    text = builtins.readFile ../scripts/agent-bell-hooks.sh;
  };
in
{
  home.file.".local/bin/agent-bell" = {
    source = ../config/bin/agent-bell;
    executable = true;
  };

  # Both tools keep mutable state in these files, so merge rather than replace.
  home.activation.agentBellHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${agentBellHooks}/bin/agent-bell-hooks \
      ${lib.escapeShellArg config.home.homeDirectory} \
      ${lib.escapeShellArg bell} \
      ${lib.escapeShellArg claudeHooks}
  '';
}
