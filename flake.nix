{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    apple-silicon-support = {
      # url = "github:tpwrules/nixos-apple-silicon";
      # url = "github:schphe/nixos-apple-silicon";
      url = "github:kitten/nixos-apple-silicon/edge";
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
