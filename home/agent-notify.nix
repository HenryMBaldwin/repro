{ config, pkgs, lib, ... }:

let
  bell = "${config.home.homeDirectory}/.local/bin/agent-bell";
  hook = [ { hooks = [ { type = "command"; command = bell; } ]; } ];
  claudeHooks = builtins.toJSON { Notification = hook; Stop = hook; };
in
{
  home.file.".local/bin/agent-bell" = {
    source = ../config/bin/agent-bell;
    executable = true;
  };

  # Both tools keep mutable state in these files, so merge rather than replace.
  home.activation.agentBellHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    claude_settings="${config.home.homeDirectory}/.claude/settings.json"
    if [ ! -e "$claude_settings" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "$claude_settings")"
      $DRY_RUN_CMD echo '{}' > "$claude_settings"
    fi
    $DRY_RUN_CMD ${pkgs.jq}/bin/jq --argjson h ${lib.escapeShellArg claudeHooks} \
      '.hooks = ((.hooks // {}) + $h)' "$claude_settings" > "$claude_settings.tmp" \
      && $DRY_RUN_CMD mv "$claude_settings.tmp" "$claude_settings"

    $DRY_RUN_CMD ${pkgs.python3}/bin/python3 - <<'PY'
    import pathlib, re
    p = pathlib.Path("${config.home.homeDirectory}/.codex/config.toml")
    p.parent.mkdir(parents=True, exist_ok=True)
    s = p.read_text() if p.exists() else ""
    if not re.search(r"^\s*notify\s*=", s, re.M):
        p.write_text('notify = ["${bell}"]\n' + s)
    PY
  '';
}
