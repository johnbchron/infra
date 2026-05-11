localFlake: { inputs, config, systems, alacritty-theme, ... }: let
  inherit (localFlake.flake-parts-lib) importApply;

  system = "aarch64-linux";
  specialArgs = inputs // { inherit inputs system; };

  commonModules = builtins.attrValues config.flake.commonModules;
  nixosModules = builtins.attrValues config.flake.nixosModules;
  darwinModules = builtins.attrValues config.flake.darwinModules;
  homeManagerModules = builtins.attrValues config.flake.homeManagerModules;

  darwinHomeManagerModule = {
    users.users.jlewis.home = "/Users/jlewis";
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.jlewis = { ... }: {
        # home.username = "jlewis";
        # home.homeDirectory = "/Users/jlewis";
        imports = homeManagerModules;
      };
      extraSpecialArgs = specialArgs;
    };
  };
  homeManagerModule = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.jlewis = { ... }: {
        imports = homeManagerModules;
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
        modules = commonModules ++ nixosModules ++ (module-list-from-dir "hosts/gimli") ++ [ homeManagerModule ];
        inherit specialArgs;
      };
      generic-vm = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules ++ nixosModules ++ (module-list-from-dir "hosts/generic-vm") ++ [ homeManagerModule ];
        inherit specialArgs;
      };
    };
    darwinConfigurations = {
      gimli-darwin = inputs.nix-darwin.lib.darwinSystem {
        modules = commonModules ++ darwinModules ++ [
          darwinHomeManagerModule
        ];
        inherit specialArgs;
      };
    };
  };
}
