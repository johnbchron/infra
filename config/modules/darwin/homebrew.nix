{ ... }: {
  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    casks = [
      "ungoogled-chromium"
      "alacritty"
      "signal"
      "obsidian"
    ];
  };
}
