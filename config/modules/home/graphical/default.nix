{ lib, osConfig, pkgs, config, ... }: let
  cfg = osConfig.graphical;
in {
  imports = if cfg.enable then [
    ./dconf.nix
  ] else [];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      floorp-bin

      anki # flashcards
      obsidian # notes & stuff
      # rpi-imager # disk imaging
      # blender # video editing & compositing
      fstl # viewing stl files
      # libreoffice-still # office stuff
      audacity # audio editing
      inkscape # vector editing
      signal-desktop # messaging
      audacity # recording

      # audio
      pulseaudio
    ] ++ (lib.optionals pkgs.stdenv.isLinux [
      # other apps
      ungoogled-chromium # alternative browser
      obs-studio # recording & streaming
      qdirstat # disk space usage
      dconf-editor # dconf obv
      vlc # video playback
      gimp # image editing
      prusa-slicer # 3d printing
      freecad # 3d modelling

      # games
      mars
      prismlauncher

      # network
      fragments
      qbittorrent

      # gnome stuff
      gnome-tweaks
      gnomeExtensions.just-perfection
    ]) ++ (lib.optionals pkgs.stdenv.isDarwin [
    ]);

    gtk = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      gtk4.theme = config.gtk.theme;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    # workaround to fix freecad
    # https://github.com/NixOS/nixpkgs/issues/467783
    xdg = lib.mkIf pkgs.stdenv.isLinux {
      systemDirs.data = [
        "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}"
      ];
    };
  };
}
