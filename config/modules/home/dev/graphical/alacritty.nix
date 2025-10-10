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
        # option_as_alt = "Both";
      };
      
      font = {
        normal =      { family = "Iosevka Term Custom"; style = "SemiBold"; };
        bold =        { family = "Iosevka Term Custom"; style = "Heavy"; };
        italic =      { family = "Iosevka Term Custom"; style = "SemiBold Italic"; };
        bold_italic = { family = "Iosevka Term Custom"; style = "Heavy Italic"; };

        size = 14;
        # builtin_box_drawing = false;
      };

      colors = theme-config.colors;
    };
  };
}
