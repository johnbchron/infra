{ lib, config, ... }: let
  cfg = config.hardware.asahi-hardware;
in {
  options = {
    hardware.asahi-hardware.enable = lib.mkEnableOption "asahi hardware config";
  };

  config = {
    hardware.asahi = {
      # switch asahi to default off
      enable = cfg.enable;

      peripheralFirmwareDirectory = lib.mkIf cfg.enable ../../../firmware;
    };

    boot = {
      # necessary for asahi boot
      loader = lib.mkIf cfg.enable {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = false;
      };

      # use full display height
      kernelParams = lib.mkIf cfg.enable [
        "appledrm.show_notch=1"
      ];

      # just for fun
      m1n1CustomLogo = lib.mkIf cfg.enable ../../../media/hexaradialis.png;
    };
  };
}
