{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steam-asahi = {
      url = "git+https://codeberg.org/ooonea/steam-asahi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alacritty-theme = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };
    iosevka-pin.url = "github:NixOS/nixpkgs?rev=77a52192a7502c2385027651c81d269cb106dbde";

    jj-watch.url = "github:johnbchron/jj-watch";

    apple-silicon-support = {
      url = "github:nix-community/nixos-apple-silicon";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (top: {
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

    imports = let
      inherit (top.flake-parts-lib) importApply;
    in [
      (importApply ./config)
    ];
  });

}
