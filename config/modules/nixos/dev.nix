{ lib, config, pkgs, jj-watch, ... }: let
  system = pkgs.stdenv.hostPlatform.system;
  cfg = config.development;

  jj-watch-overlay = final: prev: {
    jj-watch = jj-watch.packages."${system}".jj-watch;
  };
in {
  config = lib.mkIf cfg.enable {
    # enable zsh for default user shell
    programs.zsh.enable = true;

    # add jj-watch to pkgs
    # add openclaw to pkgs
    nixpkgs.overlays = [
      jj-watch-overlay
      # inputs.nix-openclaw.overlays.default
    ];

    virtualisation.docker.enable = true;

    services.ollama.enable = true;
    services.ollama.package = pkgs.ollama-vulkan;
  };
}
