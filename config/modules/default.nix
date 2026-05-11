localFlake: { inputs, ... }: {
  flake = let
    module-dir-to-imported-map = dir: (with builtins;
      listToAttrs
        (map
          # key-value of file name without extension to imported module
          (fn: {
            name = (substring 0 ((stringLength fn) - 4) fn);
            value = (import ./${dir}/${fn});
          })
          # file names in directory
          (attrNames (readDir ./${dir}))));
  in {
    commonModules = module-dir-to-imported-map "common" // {
    };
    homeManagerModules = module-dir-to-imported-map "home";
    nixosModules = module-dir-to-imported-map "nixos" // {
      home-manager = inputs.home-manager.nixosModules.home-manager;
      apple-silicon-support = inputs.apple-silicon-support.nixosModules.default;
    };
    darwinModules = module-dir-to-imported-map "darwin" // {
      home-manager = inputs.home-manager.darwinModules.home-manager;
    };
  };
}
