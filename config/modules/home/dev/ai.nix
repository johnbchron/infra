{ pkgs, nix-openclaw, ... }: {
  imports = [ nix-openclaw.homeManagerModules.openclaw ];
  
  home.packages = with pkgs; [
    claude-code

    signal-cli # for openclaw channel
  ];

  programs.openclaw = {
    enable = true;
    documents = ../../../../openclaw-documents;

    config = {
      auth = {
        profiles = {
          "anthropic:default" = {
            provider = "anthropic";
            mode = "token";
          };
        };
      };
      gateway = {
        port = 18789;
        mode = "local";
        bind = "loopback";
        auth = {
          mode = "token";
          token = "32f2bed0dc13500b27088bc7237bd43c5f3c11cf058541affcba7d9e31112955";
        };
        tailscale = {
          mode = "off";
          resetOnExit = false;
        };
        # controlUi.root = "/home/jlewis/.openclaw/control-ui";
      };
      agents = {
        defaults = {
          model = { primary = "anthropic/claude-sonnet-4-6"; };
          models = {
            "anthropic/claude-sonnet-4-6" = { alias = "Sonnet"; };
            "anthropic/claude-opus-4-6" = { alias = "Opus"; };
          };
        };
      };
    };
  };
}
