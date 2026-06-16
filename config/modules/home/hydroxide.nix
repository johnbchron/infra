{ config, lib, pkgs, ... }:

let
  cfg = config.services.hydroxide;
in
{
  options.services.hydroxide = {
    enable = lib.mkEnableOption "hydroxide ProtonMail bridge";

    package = lib.mkPackageOption pkgs "hydroxide" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address all hydroxide listeners bind to.";
    };

    imapPort = lib.mkOption { type = lib.types.port; default = 1143; };
    smtpPort = lib.mkOption { type = lib.types.port; default = 1025; };
    carddavPort = lib.mkOption { type = lib.types.port; default = 8080; };

    bridgePassFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing a single line:
          HYDROXIDE_BRIDGE_PASS=<the password hydroxide generated at auth time>
        This must be the exact 32-byte password printed by `hydroxide auth`,
        since it decrypts auth.json. Keep this file out of the Nix store
        (e.g. managed by sops-nix / agenix, or a plain root-owned file).
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.hydroxide = {
      Unit = {
        Description = "Hydroxide ProtonMail bridge";
        After = [ "network-online.target" ];
        StartLimitIntervalSec = 0;
      };

      Service = {
        ExecStart = lib.concatStringsSep " " (
          [
            "${cfg.package}/bin/hydroxide"
            "-imap-host" cfg.host
            "-imap-port" (toString cfg.imapPort)
            "-smtp-host" cfg.host
            "-smtp-port" (toString cfg.smtpPort)
            "-carddav-host" cfg.host
            "-carddav-port" (toString cfg.carddavPort)
          ]
          ++ cfg.extraArgs
          ++ [ "serve" ]
        );
        EnvironmentFile = lib.mkIf (cfg.bridgePassFile != null) cfg.bridgePassFile;
        Restart = "on-failure";
        RestartSec = 10;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
