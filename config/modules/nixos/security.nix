{ lib, config, ... } @ top: let
  cfg = config.security;
  utils = (import ../utils.nix) top;
  inherit (utils) mkEnableOptionDefaultOn;
in {
  options = {
    security.replace-sudo = {
      enable = mkEnableOptionDefaultOn "replace sudo with sudo-rs";
    };
    security.no-sudo-password-for-wheel-group = {
      enable = mkEnableOptionDefaultOn
        "allow all users belonging to group \"wheel\" to use sudo without a password";
    };
  };

  config.security = let
    # config for whichever sudo is active
    sudo-config = {
      enable = true;
      extraRules = lib.mkIf cfg.no-sudo-password-for-wheel-group.enable [{
        groups = [ "wheel" ];
        commands = [{
          command = "ALL";
          options = [ "NOPASSWD" ];
        }];
      }];
    };
  in {
    sudo = lib.mkIf (!cfg.replace-sudo.enable) sudo-config;
    sudo-rs = lib.mkIf (cfg.replace-sudo.enable) sudo-config;
  };
}
