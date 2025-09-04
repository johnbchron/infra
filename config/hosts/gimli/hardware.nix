{ ... }: {
  system.stateVersion = "23.11";

  hardware.asahi-hardware.enable = true;
  services.idevices.enable = true;

  # networking = {
  #   networkmanager.enable = true;
  #   hostName = "gimli";
  #   # for viewing local development from mobile
  #   firewall.allowedTCPPorts = [ 3000 ];
  #   nameservers = [
  #     # # google
  #     # "2001:4860:4860::8888"
  #     # "2001:4860:4860::8844"
  #     # cloudflare
  #     "2606:4700:4700::1111"
  #     "2606:4700:4700::1001"
  #   ];
  # };
}
