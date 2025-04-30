{ lib, config, pkgs, ... }: let
  cfg = config.services.idevices;
in {
  options = {
    services.idevices = {
      enable = lib.mkEnableOption "functionality for iphones";
    };
  };

  config = lib.mkIf cfg.enable {
    services.usbmuxd.enable = true;

    environment.systemPackages = with pkgs; [
      ifuse
      libimobiledevice
    ];
  };
}
