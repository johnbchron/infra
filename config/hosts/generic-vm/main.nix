{ ... }: {
  users.users.jlewis = {
    isNormalUser = true;
    password = "password";
  };

  system.stateVersion = "23.11";
}
