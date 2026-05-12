{ lib, pkgs, config, jj-watch, ... } @ top: let
  cfg = config.development;
  system = pkgs.stdenv.hostPlatform.system;

  jj-watch-overlay = final: prev: {
    jj-watch = jj-watch.packages."${system}".jj-watch;
  };

  utils = (import ../utils.nix) top;
  inherit (utils) mkEnableOptionDefaultOn;
in {
  options = {
    development = {
      enable = mkEnableOptionDefaultOn "enable development tools";
    };
  };

  config = lib.mkIf cfg.enable {
    # set default editor to helix
    environment.variables = {
      "VISUAL" = "${pkgs.helix}/bin/hx";
      "EDITOR" = "${pkgs.helix}/bin/hx";
    };

    services.openssh.enable = true;

    programs.ssh.extraConfig = ''
      Host halide
        HostName 5.78.187.180
        User root
    '';

    nixpkgs.overlays = [
      jj-watch-overlay
      # inputs.nix-openclaw.overlays.default
    ];
  };
}
