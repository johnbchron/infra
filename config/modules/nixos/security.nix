{ lib, config, ... }: let
  cfg = config.security.replace-sudo;
in {
  options = {
    security.replace-sudo = {
      enable = lib.mkEnableOption "replace sudo with sudo-rs";
    };
  };

  config.security = lib.mkIf cfg.enable {
    sudo.enable = false;
    sudo-rs.enable = true;
  };
}
