{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "maven-pro";
  version = "unstable-2025-02-07";

  src = fetchFromGitHub {
    owner = "m4rc1e";
    repo = "mavenproFont";
    rev = "a694ee80d067e6f8cad700930e78ce395d4949e6";
    hash = "sha256-hEhPQn/J0KNZNlii4DuemFRLwU8rGqXG4LDyqvXEJKU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/ttf/*.ttf -t $out/share/fonts/truetype
    install -Dm644 OFL.txt -t $out/share/doc/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Maven Pro is a sans-serif typeface with unique curvature and flowing rhythm by Joe Prince";
    homepage = "https://github.com/m4rc1e/mavenproFont";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
