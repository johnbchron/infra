{ lib, config, pkgs, ... }: let
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

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs; [
      gnome-music
      # gedit # text editor
      epiphany # web browser
      geary # email reader
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
      gnome-calendar
    ]);

    networking.networkmanager.enable = true;
  };
}
