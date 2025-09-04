{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    apple-silicon-support = {
      url = "github:nix-community/nixos-apple-silicon";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (top: {
    systems = [ "x86_64-linux" "aarch64-linux" ];

    imports = let
      inherit (top.flake-parts-lib) importApply;
    in [
      (importApply ./config)
    ];
  });

}
