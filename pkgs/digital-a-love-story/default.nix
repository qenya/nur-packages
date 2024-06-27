{ stdenv
, lib
, fetchzip
, zlib
, autoPatchelfHook
, xorg
, libpulseaudio
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "digitalalovestory-bin";
  version = "1.1";

  src = fetchzip {
    url = "https://www.scoutshonour.com/lilyofthevalley/digital-${version}.tar.bz2";
    sha256 = "+7KcZ8dKts1AoKWNfHMKIt+w2fBFIAcnkuAtzSw49xk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];

  appendRunpaths = [
    "${xorg.libX11}/lib"
    "${xorg.libXext}/lib"
    "${xorg.libXrender}/lib"
    "${xorg.libXrandr}/lib"
    "${xorg.libXcursor}/lib"
    "${libpulseaudio}/lib"
    "${alsa-lib}/lib"
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # copy distributed files
    mkdir -p $out/opt/Digital-linux-x86
    cp -R source/* $out/opt/Digital-linux-x86

    # add launcher
    mkdir -p $out/bin
    substituteAll ${./launcher.sh} $out/bin/Digital
    chmod +x $out/bin/Digital

    # add desktop file
    mkdir -p $out/share/applications
    substituteAll ${./Digital.desktop} $out/share/applications/Digital.desktop

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://scoutshonour.com/digital/";
    description = "Digital: A Love Story, a freeware game by Christine Love";
    license = licenses.cc-by-nc-sa-30;
    platforms = lists.intersectLists platforms.x86 platforms.linux;
  };
}
