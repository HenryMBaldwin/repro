home_dir="${1:?usage: agent-bell-hooks <home-dir> <bell-path> <claude-hooks-json>}"
bell="${2:?usage: agent-bell-hooks <home-dir> <bell-path> <claude-hooks-json>}"
hooks_json="${3:?usage: agent-bell-hooks <home-dir> <bell-path> <claude-hooks-json>}"

claude_settings="$home_dir/.claude/settings.json"
if [ ! -e "$claude_settings" ]; then
  mkdir -p "$(dirname "$claude_settings")"
  echo '{}' > "$claude_settings"
fi
jq --argjson h "$hooks_json" '.hooks = ((.hooks // {}) + $h)' "$claude_settings" > "$claude_settings.tmp" \
  && mv "$claude_settings.tmp" "$claude_settings"

python3 - "$home_dir" "$bell" <<'PY'
import pathlib, re, sys

home_dir, bell = sys.argv[1], sys.argv[2]
p = pathlib.Path(home_dir) / ".codex" / "config.toml"
p.parent.mkdir(parents=True, exist_ok=True)
s = p.read_text() if p.exists() else ""
if not re.search(r"^\s*notify\s*=", s, re.M):
    p.write_text(f'notify = ["{bell}"]\n' + s)
PY
