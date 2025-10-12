{ lib, config, pkgs, jj-watch, system, ... } @ top: let
  cfg = config.development;
  utils = (import ../utils.nix) top;
  inherit (utils) mkEnableOptionDefaultOn;

  jj-watch-overlay = final: prev: {
    jj-watch = jj-watch.packages."${system}".jj-watch;
  };
in {
  options = {
    development = {
      enable = mkEnableOptionDefaultOn "enable development tools";
    };
  };

  config = lib.mkIf cfg.enable {
    # enable zsh for default user shell
    programs.zsh.enable = lib.mkIf cfg.enable true;

    # add jj-watch to pkgs
    nixpkgs.overlays = [ jj-watch-overlay ];

    # set /bin/sh to dash for speed
    # environment.binsh = lib.mkIf cfg.enable pkgs.dash;

    # set default editor to helix
    environment.variables = {
      "VISUAL" = "${pkgs.helix}/bin/hx";
      "EDITOR" = "${pkgs.helix}/bin/hx";
    };

    services.openssh.enable = true;

    virtualisation.docker.enable = true;
  };
}
