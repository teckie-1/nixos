{ lib, ... }:

{
    options.myconfig.kittyFontSize = lib.mkOption {
        type = lib.types.float;
        default = 12.0;
        description = "kitty terminal font size, set per-host";
      };
  }
