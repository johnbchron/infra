{ lib, config, ... } @ top: let
  cfg = config.development;

  utils = (import ../utils.nix) top;
  inherit (utils) mkEnableOptionDefaultOn;
in {
  options = {
    development = {
      enable = mkEnableOptionDefaultOn "enable development tools";
    };
  };

  config = lib.mkIf cfg.enable {

  };
}
