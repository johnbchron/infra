{ pkgs, inputs, config, ... }: let
  lix-overlay = final: prev: {
    inherit (prev.lixPackageSets.stable)
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      colmena;
  };
in {
  # use lix packages instead of nix packages
  nixpkgs.overlays = [ lix-overlay ];
  
  nix = {
    # use the lix version of nix
    package = pkgs.lixPackageSets.stable.lix;
    
    # configure the flake registry to use the current inputs
    registry = pkgs.lib.mapAttrs (_: value: { flake = value; }) inputs;
    # configure NIX_PATH to use the current nixpkgs
    nixPath = pkgs.lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      # allow-import-from-derivation = true;
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
}
