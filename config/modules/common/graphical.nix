{ lib, config, pkgs, ... }: let
  cfg = config.graphical;
in {
  options = {
    graphical = {
      enable = lib.mkEnableOption "make this a graphical system";
    };
  };
  
  config = lib.mkIf cfg.enable {
    nixpkgs = {
      config = {
        allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          "obsidian" "claude-code" "steam-unwrapped"
        ];
      };

      overlays = let
        # fix jemalloc within difftastic
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

    fonts.packages = with pkgs; [
      iosevka-bin

      # for OS font
      roboto
      # for various things
      inter
      # oswald

      ibm-plex

      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # for obsidian body copy
      ia-writer-quattro ia-writer-duospace
    ] ++ (lib.optionals pkgs.stdenv.isDarwin (with pkgs; [
      noto-fonts
    ]));
  };
}

