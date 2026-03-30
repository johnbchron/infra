localFlake: { inputs, config, systems, alacritty-theme, ... }: let
  inherit (localFlake.flake-parts-lib) importApply;

  system = "aarch64-linux";
  specialArgs = inputs // { inherit inputs system; };

  nixosModules = builtins.attrValues config.flake.nixosModules;
  homeManagerModule = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.jlewis = { ... }: {
        imports = (builtins.attrValues config.flake.homeManagerModules) ++ [
          # inputs.bluehood.homeManagerModules.default
        ];
      };
      extraSpecialArgs = specialArgs;
    };
  };

  # collection of modules from a directory
  module-list-from-dir = dir: (with builtins;
    map
      (fn: import ./${dir}/${fn})
      (attrNames (readDir ./${dir})));
in {
  imports = [
    (importApply ./modules)
  ];

  flake = {
    lib = { inherit module-list-from-dir; };
    nixosConfigurations = {
      gimli = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = nixosModules ++ (module-list-from-dir "hosts/gimli") ++ [ homeManagerModule ];
        inherit specialArgs;
      };
      generic-vm = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = nixosModules ++ (module-list-from-dir "hosts/generic-vm") ++ [ homeManagerModule ];
        inherit specialArgs;
      };
    };
  };
}
