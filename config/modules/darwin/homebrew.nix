{ ... }: {
  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    casks = [
      # { name = "ungoogled-chromium"; args = { no-quarantine = true; }; }
      "ungoogled-chromium"
      "alacritty"
    ];
  };
}
