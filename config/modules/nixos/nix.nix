{ pkgs, inputs, config, ... }: {
  config = {
    nix = {
      registry = pkgs.lib.mapAttrs (_: value: { flake = value; }) inputs;
      nixPath = pkgs.lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      extraOptions = ''
        experimental-features = nix-command flakes ca-derivations
      '';
      settings = {
        auto-optimise-store = true;
        allow-import-from-derivation = true;
        trusted-users = [ "root" "jlewis" ];
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };
    };
  };
}
