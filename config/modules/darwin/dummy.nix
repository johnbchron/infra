{ self, ... }: {
  # all darwin systems are graphical
  graphical.enable = true;

  system = {
    # set the primary user, because darwin-rebuild must be run as root
    primaryUser = "jlewis";

    # set git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  # the platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # enable touch-id for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
