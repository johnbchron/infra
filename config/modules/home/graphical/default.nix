{ lib, osConfig, pkgs, ... }: let
  cfg = osConfig.graphical;
in {
  imports = if cfg.enable then [
    ./dconf.nix
  ] else [];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      floorp-bin
      ungoogled-chromium

      # other apps
      anki # flashcards
      obsidian # notes & stuff
      # rpi-imager # disk imaging
      obs-studio # recording & streaming
      # blender # video editing & compositing
      qdirstat # disk space usage 
      vlc # video playback
      fstl # viewing stl files
      gimp # image editing
      # libreoffice-still # office stuff
      audacity # audio editing
      fragments # torrents
      inkscape # vector editing
      dconf-editor # dconf obv
      signal-desktop # messaging
      prusa-slicer # 3d printing
      freecad # 3d modelling
      audacity # recording

      # games
      mars
      prismlauncher

      # network
      qbittorrent

      # gnome stuff
      gnome-tweaks
      gnomeExtensions.just-perfection

      # audio
      pulseaudio
    ];

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    # workaround to fix freecad
    # https://github.com/NixOS/nixpkgs/issues/467783
    xdg.systemDirs.data = [
      "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}"
    ];
  };
}
