{ ... }: {
  users = {
    users.jlewis = {
      description = "John Lewis";

      hashedPassword =
        "$y$j9T$t9QF7ZvlqxQW1fyt1oXY71$zVNJaxzDDt/ylja/9ypszO.Ii.wuESwqC.1HN43OLx1";

      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
