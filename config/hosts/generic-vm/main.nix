{ ... }: {
  system.stateVersion = "23.11";

  graphical.enable = true;
  
  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;
  };
}
