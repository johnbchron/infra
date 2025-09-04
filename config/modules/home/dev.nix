{ lib, osConfig, ... }: let
  cfg = osConfig.development;
in {
  # shell history
  programs.atuin = lib.mkIf cfg.enable {
    settings = {
      inline_height = 0;
      enter_accept = true;
    };
    enable = true;
  };
  
}
