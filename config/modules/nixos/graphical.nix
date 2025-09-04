{ lib, config, ... }: let
  cfg = config.graphical;
in {
  options = {
    graphical = {
      enable = lib.mkEnableOption "make this a graphical system";
    };
  };
  
  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;

    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    networking.networkmanager.enable = true;
  };
}
