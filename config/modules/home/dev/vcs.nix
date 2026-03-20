{ pkgs, ... }: {
  # allow better snapshotting for JJ
  home.packages = [
    pkgs.watchman
  ];
  
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "github@jlewis.sh";
        name = "John Lewis";
      };

      templates = {
        log = "builtin_log_comfortable";

        # added another newline before the diff summary
        draft_commit_description = ''
          concat(
            description,
            surround(
              "\n\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.summary()),
            ),
          )
        '';
      };

      ui = {
        default-command = [ "log" ];

        diff-formatter = ["${pkgs.difftastic}/bin/difft" "--color=always" "$left" "$right"];
      };

      signing = {
        behavior = "own";
        backend = "gpg";
      };

      git = {
        sign-on-push = true;
      };

      fsmonitor.backend = "watchman";
    };
  };

  programs.git = {
    enable = true;
    ignores = [ ".direnv" "result" ".jj" ".claude" ];

    signing = {
      # signByDefault = true;
      key = "0x89C8A7794A74A0AB";
    };

    lfs.enable = true;

    settings = {
      user = {
        name = "John Lewis";
        email = "github@jlewis.sh";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      diff.external = "${pkgs.difftastic}/bin/difft";
      alias = {
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --branches";
      };
    };
  };

  programs.gitui = {
    enable = true;
    # sourced from https://github.com/catppuccin/gitui/blob/main/theme/macchiato.ron
    theme = ''
      (
          selected_tab: Some(Reset),
          command_fg: Some(Rgb(202, 211, 245)),
          selection_bg: Some(Rgb(91, 96, 120)),
          selection_fg: Some(Rgb(202, 211, 245)),
          cmdbar_bg: Some(Rgb(30, 32, 48)),
          cmdbar_extra_lines_bg: Some(Rgb(30, 32, 48)),
          disabled_fg: Some(Rgb(128, 135, 162)),
          diff_line_add: Some(Rgb(166, 218, 149)),
          diff_line_delete: Some(Rgb(237, 135, 150)),
          diff_file_added: Some(Rgb(238, 212, 159)),
          diff_file_removed: Some(Rgb(238, 153, 160)),
          diff_file_moved: Some(Rgb(198, 160, 246)),
          diff_file_modified: Some(Rgb(245, 169, 127)),
          commit_hash: Some(Rgb(183, 189, 248)),
          commit_time: Some(Rgb(184, 192, 224)),
          commit_author: Some(Rgb(125, 196, 228)),
          danger_fg: Some(Rgb(237, 135, 150)),
          push_gauge_bg: Some(Rgb(138, 173, 244)),
          push_gauge_fg: Some(Rgb(36, 39, 58)),
          tag_fg: Some(Rgb(244, 219, 214)),
          branch_fg: Some(Rgb(139, 213, 202))
      )
    '';
  };
}

