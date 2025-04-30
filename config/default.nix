localFlake: { inputs, config, systems, ... }: let
  inherit (localFlake.flake-parts-lib) importApply;

  nixosModules = builtins.attrValues config.flake.nixosModules;

  # collection of modules from a directory
  module-list-from-dir = dir: (with builtins;
    map
      (fn: import ./${dir}/${fn})
      (attrNames (readDir ./${dir})));
in {
  imports = [
    (importApply ./modules)
  ];

  flake.nixosConfigurations = {
    gimli = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = nixosModules ++ (module-list-from-dir "hosts/gimli");
    };
    generic-vm = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = nixosModules ++ (module-list-from-dir "hosts/generic-vm");
    };
  };
}
