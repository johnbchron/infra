{ osConfig, ... }: let
  cfg = osConfig.development;
in {
  imports = if cfg.enable then [
    ./shell
    ./programs.nix
    ./git.nix
    ./helix.nix
  ] else [];
}
