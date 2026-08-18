.PHONY: bootstrap switch update

PROFILE ?=

bootstrap:
	@test -n "$(PROFILE)" || { echo "error: pass a profile, e.g. make bootstrap PROFILE=mac"; exit 1; }
	./bootstrap.sh $(PROFILE)

switch:
	@test -n "$(PROFILE)" || { echo "error: pass a profile, e.g. make switch PROFILE=mac"; exit 1; }
	./bootstrap.sh $(PROFILE)

update:
	nix flake update
