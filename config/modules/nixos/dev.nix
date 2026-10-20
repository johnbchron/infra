{ pkgs, lib, config, ... }: let
  cfg = config.development;
in {
  config = lib.mkIf cfg.enable {
    # enable zsh for default user shell
    programs.zsh.enable = true;

    virtualisation.docker.enable = true;

    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };

    services.guix = {
      enable = true;
    };
  };
}
