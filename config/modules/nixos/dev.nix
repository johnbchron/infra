{ inputs, lib, config, pkgs, jj-watch, nix-openclaw, ... } @ top: let
  system = pkgs.stdenv.hostPlatform.system;
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
    # add openclaw to pkgs
    nixpkgs.overlays = [
      jj-watch-overlay
      nix-openclaw.overlays.default
    ];

    # set /bin/sh to dash for speed
    # environment.binsh = lib.mkIf cfg.enable pkgs.dash;

    # set default editor to helix
    environment.variables = {
      "VISUAL" = "${pkgs.helix}/bin/hx";
      "EDITOR" = "${pkgs.helix}/bin/hx";
    };

    services.openssh.enable = true;

    virtualisation.docker.enable = true;

    services.ollama.enable = true;

    # # allow bluehood the capabilities it needs
    # security.wrappers.bluehood = {
    #   source = "${inputs.bluehood.packages."${system}".default}/bin/bluehood";
    #   capabilities = "cap_net_admin,cap_net_raw+eip";
    #   owner = "root"; group = "root";
    # };
  };
}
