{ lib, config, ... }: let
  cfg = config.development;
in {
  config = lib.mkIf cfg.enable {
    # enable zsh for default user shell
    programs.zsh.enable = true;

    virtualisation.docker.enable = true;

    services.guix = {
      enable = true;
    };
  };
}
