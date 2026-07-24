{ config, lib, ... }:

{
  options.my.claudeRules = lib.mkOption {
    type = with lib.types; listOf lines;
    default = [ ];
  };

  config = {
    my.claudeRules = [
      ''
        # Code style
        Write only strictly-necessary code comments; default to none. Don't add comments that restate the code, narrate refactors, or document changes. Only comment when intent is genuinely non-obvious.
      ''
    ];

    home.file.".claude/CLAUDE.md".text =
      lib.concatStringsSep "\n" config.my.claudeRules;
  };
}
