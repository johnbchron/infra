{ pkgs, ... }: {
  system.stateVersion = "23.11";

  hardware.asahi-hardware.enable = true;
  services.idevices.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils # lsusb
  ];

  graphical.enable = true;

  networking = {
    networkmanager.enable = true;

    hostName = "gimli";

    firewall.allowedTCPPorts = [ 3000 ];

    nameservers = [
      # google
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
      # cloudflare
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
  };
}
