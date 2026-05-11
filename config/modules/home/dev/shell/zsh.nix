{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    history.size = 3000;
    shellAliases = let
      tree = "eza --tree --all --long --header --total-size --git --git-repos --mounts --hyperlink";
    in {
      cg = "cd $(git rev-parse --show-toplevel)";
      cleanup-dev = "rm -rf ~/github/*/{.direnv/,result} ~/playground/*/{.direnv/,result}";
      clr = "clear";
      daily = "command hx \"~/obsidian/main/Daily Notes/$(date +'%Y-%m-%d').md\"";
      e = "exit";
      gu = "gitui";
      neofetch = "fastfetch";
      l = "eza --all --long --header --total-size --git --git-repos --mounts --hyperlink";
      ls = "eza";
      rt = "zellij action rename-tab \"$(basename \"$PWD\")\" && echo \"renamed zellij tab to \\\"$(basename \"$PWD\")\\\" (working directory)\"";
      q = "exit";
      rebuild = if pkgs.stdenv.isDarwin then
        "sudo darwin-rebuild switch --flake /Users/jlewis/infra#gimli-darwin" else
        "sudo nixos-rebuild switch --flake /home/jlewis/infra";
      speed = "cfspeedtest";
      inherit tree;
      treeg = tree + " --git-ignore";
      with-rust = "nix develop \"/home/jlewis/github/with-rust\" --command $SHELL";
      with-typst = "nix develop \"/home/jlewis/github/with-typst\" --command $SHELL";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "nix-shell" ];
      custom = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/jlewis/.config/ohmyzsh_custom";
    };

    syntaxHighlighting = {
      enable = true;
    };
  };

  # nix-shell custom zsh plugin
  home.file.ohmyzsh-nix-shell = let
    nix-shell-repo = pkgs.fetchgit {
      url = "https://github.com/chisui/zsh-nix-shell";
      rev = "82ca15e638cc208e6d8368e34a1625ed75e08f90";
      hash = "sha256-Rtg8kWVLhXRuD2/Ctbtgz9MQCtKZOLpAIdommZhXKdE=";
    };
  in {
    source = "${nix-shell-repo}";
    target = ".config/ohmyzsh_custom/plugins/nix-shell";
  };
}
