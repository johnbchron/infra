{ ... } @ top: let
  utils = (import ../utils.nix) top;
  inherit (utils) mkEnableOptionDefaultOn;
in {
  options = {
    security.gpg = {
      enable = mkEnableOptionDefaultOn "enable gpg & agent";
    };
  };
}

