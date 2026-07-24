.PHONY: bootstrap switch update

# Profile must be passed explicitly, e.g.:
#   make bootstrap PROFILE=mac
#   make bootstrap PROFILE=linux
#   make bootstrap PROFILE=linux-devbox
PROFILE ?=

# One-shot bootstrap from a fresh clone: installs Nix if needed, then applies
# the given Home Manager profile.
bootstrap:
	@test -n "$(PROFILE)" || { echo "error: pass a profile, e.g. make bootstrap PROFILE=mac"; exit 1; }
	./bootstrap.sh $(PROFILE)

# Re-apply the config after editing .nix files or configs.
switch:
	@test -n "$(PROFILE)" || { echo "error: pass a profile, e.g. make switch PROFILE=mac"; exit 1; }
	nix run home-manager -- switch --flake ".#$(PROFILE)"

# Update flake inputs (nixpkgs, home-manager, ...).
update:
	nix flake update
