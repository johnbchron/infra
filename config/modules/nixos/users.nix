{ lib, config, pkgs, ... }: {
  users = {
    defaultUserShell = lib.mkIf config.development.enable pkgs.zsh;

    users.jlewis = {
      description = "John Lewis";

      # produced with `mkpasswd -m sha512crypt`
      hashedPassword = "$6$03MpyGkCwYHr8IrR$CqN9OyLrRJX1Afsr4h58Dg2gM9.y650j5zO0T7PwMwrth5o.5yzPfzoKvjB2IgP2ozHKa2uCH4CfrCB2JDz1P1";

      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
