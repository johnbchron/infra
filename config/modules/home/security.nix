{ lib, osConfig, pkgs, ... }: let
  cfg = osConfig.security.gpg;
  isLinux = pkgs.stdenv.isLinux;

  pinentry_package = if isLinux then pkgs.pinentry-gnome3 else pkgs.pinentry_mac;
in {
  programs.gpg.enable = cfg.enable;

  services.gpg-agent = lib.mkIf cfg.enable {
    enable = true;
    pinentry.package = pinentry_package;
    enableSshSupport = true;
  };
}
