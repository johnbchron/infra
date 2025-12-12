{ lib, config, pkgs, ... }: let
  cfg = config.hardware.asahi-hardware;
in {
  options = {
    hardware.asahi-hardware.enable = lib.mkEnableOption "asahi hardware config";
  };

  config = {
    hardware.graphics.package =
      # Workaround for Mesa 25.3.0/.1 regression
      # https://github.com/nix-community/nixos-apple-silicon/issues/380
      assert pkgs.mesa.version == "25.3.1";
      (import (fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/c5ae371f1a6a7fd27823bc500d9390b38c05fa55.tar.gz";
        sha256 = "sha256-4PqRErxfe+2toFJFgcRKZ0UI9NSIOJa+7RXVtBhy4KE=";
      }) { localSystem = pkgs.stdenv.hostPlatform; }).mesa;
    
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
        "apple_dcp.show_notch=1"
      ];

      # just for fun
      m1n1CustomLogo = lib.mkIf cfg.enable ../../../media/hexaradialis.png;
    };
  };
}
