localFlake: { inputs, config, systems, ... }: let
  inherit (localFlake.flake-parts-lib) importApply;

  nixosModules = builtins.attrValues config.flake.nixosModules;
  homeManagerModule = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.jlewis = { ... }: {
        imports = builtins.attrValues config.flake.homeManagerModules;
      };
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
        system = "aarch64-linux";
        modules = nixosModules ++ (module-list-from-dir "hosts/gimli") ++ [ homeManagerModule ];
      };
      generic-vm = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = nixosModules ++ (module-list-from-dir "hosts/generic-vm") ++ [ homeManagerModule ];
      };
    };
  };
}
