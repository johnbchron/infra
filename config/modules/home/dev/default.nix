{ osConfig, ... }: let
  cfg = osConfig.development;

  base = [
    ./shell
    ./programs.nix
    ./vcs.nix
    ./helix.nix
  ];
  graphical = if osConfig.graphical.enable then [ ./graphical ] else [];
in {
  imports = if cfg.enable then (base ++ graphical) else [];
}
