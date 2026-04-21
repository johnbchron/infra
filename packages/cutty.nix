{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,

  cmake,
  installShellFiles,
  makeWrapper,
  ncurses,
  pkg-config,
  python3,
  scdoc,

  expat,
  fontconfig,
  freetype,
  libGL,
  libxxf86vm,
  libxi,
  libxcursor,
  libx11,
  libxcb,
  libxkbcommon,
  wayland,
  xdg-utils,

  nix-update-script,
  withGraphics ? false,
  versionCheckHook,
}:
let
  rpathLibs = [
    expat
    fontconfig
    freetype
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxcursor
    libxi
    libxxf86vm
    libxcb
    libxkbcommon
    wayland
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cutty${lib.optionalString withGraphics "-graphics"}";
  version = "0.18.4";

  src =
    fetchFromGitHub {
      owner = "gold-silver-copper";
      repo = "cutty";
      tag = "v${finalAttrs.version}";
      hash = "sha256-PDMRXQBmwyRJhaX2AE19QaxOHhL5y6Al/Z/tLgFSZRo=";
    };

  cargoHash = "sha256-paGFRE5Aa+W0SPdOsAGyrk3lEzreJAFSMBeOyU5cbbY=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    makeWrapper
    ncurses
    pkg-config
    python3
    scdoc
  ];

  buildInputs = rpathLibs;

  outputs = [
    "out"
    "terminfo"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace cutty/src/config/ui_config.rs \
      --replace xdg-open ${xdg-utils}/bin/xdg-open
  '';

  checkFlags = [ "--skip=term::test::mock_term" ]; # broken on aarch64

  postInstall =
    (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir $out/Applications
          cp -r extra/osx/CuTTY.app $out/Applications
          ln -s $out/bin $out/Applications/CuTTY.app/Contents/MacOS
        ''
      else
        ''
          install -D extra/linux/CuTTY.desktop -t $out/share/applications/
          install -D extra/linux/org.cutty.CuTTY.appdata.xml -t $out/share/appdata/
          # CuTTY doesn't have an SVG, unlike Alacritty
          # install -D extra/logo/compat/cutty-term.svg $out/share/icons/hicolor/scalable/apps/CuTTY.svg
          install -D extra/logo/cutty-term.png $out/share/icons/hicolor/512x512/apps/CuTTY.png

          # patchelf generates an ELF that binutils' "strip" doesn't like:
          #    strip: not enough room for program headers, try linking with -N
          # As a workaround, strip manually before running patchelf.
          $STRIP -S $out/bin/cutty

          patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/cutty
        ''
    )
    + ''
      installShellCompletion --zsh extra/completions/_cutty
      installShellCompletion --bash extra/completions/cutty.bash
      installShellCompletion --fish extra/completions/cutty.fish

      install -dm 755 "$out/share/man/man1"
      install -dm 755 "$out/share/man/man5"

      scdoc < extra/man/cutty.1.scd | gzip -c > $out/share/man/man1/cutty.1.gz
      scdoc < extra/man/cutty-msg.1.scd | gzip -c > $out/share/man/man1/cutty-msg.1.gz
      scdoc < extra/man/cutty.5.scd | gzip -c > $out/share/man/man5/cutty.5.gz
      scdoc < extra/man/cutty-bindings.5.scd | gzip -c > $out/share/man/man5/cutty-bindings.5.gz

      install -dm 755 "$terminfo/share/terminfo/a/"
      tic -xe cutty,cutty-direct -o "$terminfo/share/terminfo" extra/cutty.info
      mkdir -p $out/nix-support
      echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    '';

  dontPatchELF = true;

  passthru = {
    tests.test = nixosTests.terminal-emulators.cutty;
    updateScript = nix-update-script { };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
})
