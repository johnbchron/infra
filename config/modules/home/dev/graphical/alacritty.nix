{ pkgs, alacritty-theme, ... }: let
  theme-name = "catppuccin_mocha";
  # theme-name = "miasma";

  theme-config = builtins.fromTOML
    (builtins.readFile "${alacritty-theme}/themes/${theme-name}.toml");
in {
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-c" "zellij" ];
      };
    
      window = {
        # opacity = 0.94;
        # blur = true;
        startup_mode = "Fullscreen";
        dynamic_padding = true;
        option_as_alt = "Both";
      };
      
      font = if pkgs.stdenv.isLinux then {
        normal =      { family = "Iosevka Term Custom"; style = "Regular"; };
        bold =        { family = "Iosevka Term Custom"; style = "Heavy"; };
        italic =      { family = "Iosevka Term Custom"; style = "Italic"; };
        bold_italic = { family = "Iosevka Term Custom"; style = "Heavy Italic"; };

        size = 14;
      } else {
        normal =      { family = "Noto Sans Mono"; style = "Medium"; };
        bold =        { family = "Noto Sans Mono"; style = "Heavy"; };
        italic =      { family = "Noto Sans Mono"; style = "Medium Italic"; };
        bold_italic = { family = "Noto Sans Mono"; style = "Heavy Italic"; };

        size = 14;
      };

      colors = theme-config.colors;
    };
  };
}
