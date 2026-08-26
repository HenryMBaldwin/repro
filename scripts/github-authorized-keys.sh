user="${1:?usage: github-authorized-keys <github-user>}"
ak="$HOME/.ssh/authorized_keys"
begin="# >>> home-manager: github.com/$user.keys >>>"
end="# <<< home-manager: github.com/$user.keys <<<"

keys="$(curl -fsSL --max-time 10 "https://github.com/$user.keys" || true)"
if [ -z "$keys" ]; then
  echo "github-authorized-keys: could not fetch keys for $user; leaving authorized_keys unchanged" >&2
  exit 0
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$ak"

kept="$(awk -v b="$begin" -v e="$end" '$0==b{skip=1;next} $0==e{skip=0;next} !skip{print}' "$ak")"

tmp="$(mktemp)"
printf '%s\n' "$kept" > "$tmp"
printf '%s\n%s\n%s\n' "$begin" "$keys" "$end" >> "$tmp"
install -m 600 "$tmp" "$ak"
rm -f "$tmp"
