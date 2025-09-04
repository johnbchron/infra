{ ... }: {
  # replacement for `cat`
  programs.bat.enable = true;

  # system monitors
  programs.btop.enable = true;
  programs.bottom.enable = true;

  # replacement for `ls`
  programs.eza.enable = true;
  
  # replacement for `grep`
  programs.ripgrep.enable = true;
}

