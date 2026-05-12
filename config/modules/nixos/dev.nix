{ lib, config, pkgs, ... }: let
  cfg = config.development;
in {
  config = lib.mkIf cfg.enable {
    # enable zsh for default user shell
    programs.zsh.enable = true;

    virtualisation.docker.enable = true;

    services.ollama.enable = true;
    services.ollama.package = pkgs.ollama-vulkan;
  };
}
