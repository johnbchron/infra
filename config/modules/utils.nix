{ lib, ... }: {
  mkEnableOptionDefaultOn = desc: (lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = true;
    description = desc;
  });
}
