{ lib, config, pkgs, system, iosevka-pin, ... }: let
  cfg = config.graphical;
in {
  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;

    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;

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

    nixpkgs = {
      overlays = let
        difftastic-jemalloc-fixup-overlay = final: prev: {
          difftastic = prev.difftastic.overrideAttrs (
            prev.lib.optionalAttrs (final.stdenv.system == "aarch64-linux") {
              JEMALLOC_SYS_WITH_LG_PAGE = 16;
            }
          );
        };
      in [
        difftastic-jemalloc-fixup-overlay
      ];
    };

    services.pipewire.enable = true;
    services.pipewire.wireplumber.enable = true;

    programs.dconf.enable = true;
    services.printing.enable = true;

    fonts.packages = with pkgs; [
      iosevka-custom
      iosevka-term-custom
    ];
  };
}
