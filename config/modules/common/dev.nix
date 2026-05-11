{ lib, pkgs, config, ... } @ top: let
  cfg = config.development;

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
  };
}
