{ lib, config, pkgs, ... } @ top: let
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
    # enable zsh for default user shell
    programs.zsh.enable = lib.mkIf cfg.enable true;

    # set /bin/sh to dash for speed
    # environment.binsh = lib.mkIf cfg.enable pkgs.dash;

    environment.variables = {
      "VISUAL" = "${pkgs.helix}/bin/hx";
      "EDITOR" = "${pkgs.helix}/bin/hx";
    };

    services.openssh.enable = true;

    virtualisation.docker.enable = true;
  };
}
