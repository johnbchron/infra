{ lib, config, pkgs, system, iosevka-pin, ... }: let
  cfg = config.graphical;
in {
  options = {
    graphical = {
      enable = lib.mkEnableOption "make this a graphical system";
    };
  };
  
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
      config = {
        allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          "obsidian" "claude-code"
        ];
      };

      overlays = let
        # pinned nixpkgs for iosevka, with the customizations
        iosevka-pin-pkgs = import iosevka-pin {
          inherit system;
          overlays = [ (import ../../../extra/iosevka-config.nix) ];
        };
        iosevka-overlay = final: prev: {
          inherit (iosevka-pin-pkgs) iosevka-custom iosevka-term-custom;
        };
        difftastic-jemalloc-fixup-overlay = final: prev: {
          difftastic = prev.difftastic.overrideAttrs (
            prev.lib.optionalAttrs (final.stdenv.system == "aarch64-linux") {
              JEMALLOC_SYS_WITH_LG_PAGE = 16;
            }
          );
        };

        # freecad-fix-overlay = final: prev: {
        #   freecad = prev.freecad.overrideAttrs (old: {
        #     nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.wrapGAppsHook3 ];
        #   });
        # };
      in [
        iosevka-overlay
        difftastic-jemalloc-fixup-overlay
        # freecad-fix-overlay
      ];
    };

    services.pipewire.enable = true;
    services.pipewire.wireplumber.enable = true;

    programs.dconf.enable = true;
    services.printing.enable = true;

    fonts.packages = with pkgs; [
      # for OS font
      roboto
      # for various things
      inter
      # oswald

      ibm-plex

      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # for the terminal
      iosevka-custom
      iosevka-term-custom

      # for obsidian body copy
      ia-writer-quattro ia-writer-duospace
    ];
  };
}
