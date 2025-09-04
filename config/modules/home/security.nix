{ lib, osConfig, pkgs, ... }: let
  cfg = osConfig.security.gpg;
in {
  config = lib.mkIf cfg.enable {
    # gpg
    programs.gpg.enable = true;

    # gpg agent
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3;
      enableSshSupport = true;
    };
  };
}
