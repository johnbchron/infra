{ ... }: {
  services.hydroxide = {
    enable = true;
    bridgePassFile = "/home/jlewis/keys/hydroxide-bridge-pass";
  };

  programs.thunderbird = {
    # enable = true;
    profiles.default.isDefault = true;
  };

  accounts.email.accounts.proton = {
    primary = true;
    address = "main@jlewis.sh";
    userName = "jlewis.sh";
    realName = "John Lewis";

    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls.enable = false;
    };

    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls.enable = false;
    };

    thunderbird = {
      enable = true;
      profiles = [ "default" ];
    };
  };

  accounts.contact.accounts.proton = {
    remote = {
      type = "carddav";
      url = "http://127.0.0.1:8080";
      userName = "jlewis.sh";
    };
    thunderbird.enable = true;
  };
}
