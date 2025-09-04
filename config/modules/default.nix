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
    nixosModules = module-dir-to-imported-map "nixos" // {
      apple-silicon-support = inputs.apple-silicon-support.nixosModules.default;
      home-manager = inputs.home-manager.nixosModules.home-manager;
    };
    homeManagerModules = module-dir-to-imported-map "home";
  };
}
