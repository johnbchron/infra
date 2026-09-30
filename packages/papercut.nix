{ stdenv, lib, jdk25, makeWrapper }:

stdenv.mkDerivation {
  pname = "papercut-user-client";
  version = "PaperCut NG 26.0.5 (Build 76603)";

  # This tells Nix to use the files you downloaded in Part 1
  src = ../papercut-client-files;

  # Add dependencies
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk25 ]; # The client requires Java [cite: 506]

  # Don't try to build anything, just install
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    # Create directories in the Nix store
    mkdir -p $out/lib/papercut
    mkdir -p $out/bin

    # Copy all the client files into the package
    cp -r $src/* $out/lib/papercut/
    chmod +x $out/lib/papercut/pc-client-linux.sh

    # Create a wrapper script in $out/bin.
    # This ensures the script can find the correct Java path.
    makeWrapper $out/lib/papercut/pc-client-linux.sh $out/bin/papercut-client \
      --set JAVA_HOME "${jdk25.home}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "PaperCut User Client (DEI)";
    platforms = platforms.linux;
  };
}
