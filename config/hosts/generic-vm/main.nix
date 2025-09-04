{ ... }: {
  system.stateVersion = "23.11";

  graphical.enable = true;

  networking.hostName = "vimli";
  
  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;
  };
}
