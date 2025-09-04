{ ... }: {
  imports = [ ./zsh.nix ];
  
  # shell history
  programs.atuin = {
    settings = {
      inline_height = 0;
      enter_accept = true;
    };
    enable = true;
  };

  # automatic project environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # extra-fancy prompt
  programs.starship = {
    enable = true;
    settings = {
      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "💀 ";
      };
      character = {
        success_symbol = "[ <->>](bold green)";
        error_symbol = "[ <](bold green)[-](bold red)[>>](bold green)";
      };
      directory = {
        truncation_length = 8;
        truncation_symbol = ">";
        truncate_to_repo = false;
      };
      direnv = {
        disabled = false;

        format = "with [$symbol$loaded/$allowed](bold yellow) ";
        allowed_msg = "a";
        not_allowed_msg = "n";
        denied_msg = "d";
        loaded_msg = "l";
        unloaded_msg = "u";
      };
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state]($style) ";
      };
    };
    enableZshIntegration = true;
  };

  # terminal multiplexer
  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      default_layout = "compact";
      session_serialization = false;
      show_startup_tips = false;
      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };
      advanced_mouse_actions = false;
    };
  };
}
