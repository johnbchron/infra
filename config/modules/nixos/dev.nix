{ lib, config, pkgs, ... } @ top: let
  cfg = config.development;
  utils = (import ../utils.nix) top;
  inherit (utils) mkEnableOptionDefaultOn;
in {
  options = {
    development = {
      enable = mkEnableOptionDefaultOn "replace sudo with sudo-rs";
    };
  };

  # enable zsh for default user shell
  config.programs.zsh.enable = lib.mkIf cfg.enable true;

  # set /bin/sh to dash for speed
  config.environment.binsh = lib.mkIf cfg.enable pkgs.dash;
}
