localFlake: { inputs, config, systems, alacritty-theme, ... }: let
  inherit (localFlake.flake-parts-lib) importApply;

  system = "aarch64-linux";
  specialArgs = inputs // { inherit inputs system; };

  commonModules = builtins.attrValues config.flake.commonModules;
  nixosModules = builtins.attrValues config.flake.nixosModules;
  homeManagerModules = builtins.attrValues config.flake.homeManagerModules;

  darwinHomeManagerModule = {
    users.users.jlewis.home = "/Users/jlewis";
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.jlewis = { ... }: {
        home.username = "jlewis";
        # home.homeDirectory = "/Users/jlewis";

        imports = commonModules ++ homeManagerModules ++ [
          # ./modules/home/dev/helix.nix
          # ./modules/home/dev/shell
          # ./modules/home/dev/programs.nix
          # ./modules/home/dev/graphical/default.nix
          # ./modules/home/base.nix
        ];
      };
      extraSpecialArgs = specialArgs;
    };
  };
  homeManagerModule = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.jlewis = { ... }: {
        imports = homeManagerModules ++ [
          # inputs.bluehood.homeManagerModules.default
        ];
      };
      extraSpecialArgs = specialArgs;
    };
  };

  jj-watch-overlay-module = { inputs, system, ... }: {
    nixpkgs.overlays = [
      (final: prev: {
        jj-watch = inputs.jj-watch.packages."${system}".jj-watch;
      })
    ];
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
        modules = [
          ./modules/nixos/nix.nix
          jj-watch-overlay-module
          ({ self, ... }: {
            # Necessary for using flakes on this system.
            # nix.settings.experimental-features = "nix-command flakes";

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 6;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = "aarch64-darwin";
          })
          inputs.home-manager.darwinModules.home-manager
          darwinHomeManagerModule
        ];
        inherit specialArgs;
      };
    };
  };
}
