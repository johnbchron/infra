{ pkgs, alacritty-theme, ... }: let
  theme-name = "catppuccin_mocha";

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
        normal =      { family = "Iosevka Term"; style = "Semibold"; };
        bold =        { family = "Iosevka Term"; style = "Heavy"; };
        italic =      { family = "Iosevka Term"; style = "Semibold Italic"; };
        bold_italic = { family = "Iosevka Term"; style = "Heavy Italic"; };

        size = 14;
      } else {
        normal =      { family = "Iosevka Term"; style = "Regular"; };
        bold =        { family = "Iosevka Term"; style = "Bold"; };
        italic =      { family = "Iosevka Term"; style = "Regular Italic"; };
        bold_italic = { family = "Iosevka Term"; style = "Bold Italic"; };

        size = 14;
      };

      colors = theme-config.colors;
    };
  };
}
