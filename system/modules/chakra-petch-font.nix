{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "chakra-petch";
  version = "unstable-2018-08-24";

  src = fetchFromGitHub {
    owner = "cadsondemak";
    repo = "Chakra-Petch";
    rev = "3fc2b8f9443f871cc431ec4feb7c1a538c30e634";
    hash = "sha256-uvaURKQFk+GjHh+cPh5UDDHx+tDtcv/ZkvX7kB5oeWM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/*.ttf -t $out/share/fonts/truetype
    install -Dm644 fonts/*.woff -t $out/share/fonts/woff
    install -Dm644 fonts/*.woff2 -t $out/share/fonts/woff2
    install -Dm644 fonts/*.eot -t $out/share/fonts/eot
    install -Dm644 OFL.txt -t $out/share/doc/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Chakra Petch font family designed by Cadson Demak";
    homepage = "https://github.com/cadsondemak/Chakra-Petch";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
