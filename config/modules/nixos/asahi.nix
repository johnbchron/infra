{ lib, config, ... }: let
  cfg = config.hardware.asahi-hardware;
in {
  options = {
    hardware.asahi-hardware.enable = lib.mkEnableOption "asahi hardware config";
  };

  config = lib.mkIf cfg.enable {
    hardware.asahi = {
      enable = true;
      peripheralFirmwareDirectory = ../../../firmware;
    };

    # turn off ambient light sensor
    hardware.sensor.iio.enable = false;

    boot = {
      # necessary for asahi boot
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = false;
      };

      kernelParams = [
        # use full display height
        "appledrm.show_notch=1"

        # use zswap
        "zswap.enabled=1"
        "zswap.compressor=zstd"
        "zswap.zpool=zsmalloc"
        "zswap.max_pool_percent=20"
      ];


      # just for fun
      m1n1CustomLogo = ../../../media/hexaradialis.png;
    };
  };
}
