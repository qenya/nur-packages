{ stdenv
, lib
, fetchzip
, python
}:

stdenv.mkDerivation rec {
  pname = "digitalalovestory";
  version = "1.1";

  broken = true; # haven't got around to figuring out what python modules are needed

  src = fetchzip {
    url = "https://www.scoutshonour.com/lilyofthevalley/digital-${version}.tar.bz2";
    sha256 = "+7KcZ8dKts1AoKWNfHMKIt+w2fBFIAcnkuAtzSw49xk=";
  };

  buildInputs = [
    python
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # copy distributed files
    mkdir -p $out/opt/Digital-linux-x86
    cp -R source/* $out/opt/Digital-linux-x86

    # patch paths in entrypoint
    sed -i 's#exec "`dirname \\"$0\\"`/lib/python"#exec "${python}/bin/python"#g' $out/opt/Digital-linux-x86/Digital.sh
    sed -i "s#\''${0%\\.sh}#$out/opt/Digital-linux-x86/Digital#g" $out/opt/Digital-linux-x86/Digital.sh
    sed -i "s#dir=.*#dir=$out/opt/Digital-linux-x86#g" $out/opt/Digital-linux-x86/Digital.sh
    sed -i 's/base=.*/base=Digital.sh/g' $out/opt/Digital-linux-x86/Digital.sh

    # link entrypoint to bin directory
    mkdir -p $out/bin
    ln -s $out/opt/Digital-linux-x86/Digital.sh $out/bin/Digital

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://scoutshonour.com/digital/";
    description = "Digital: A Love Story, a freeware game by Christine Love";
    license = licenses.cc-by-nc-sa-30;
    platforms = lists.intersectLists platforms.x86 platforms.linux;
  };
}