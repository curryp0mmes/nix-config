{
  pkgs,
  stdenv,
  lib,
  fetchurl,
  ...
}:

stdenv.mkDerivation rec {
  pname = "jlcone";
  version = "1.0.72";

  src = fetchurl {
    url = "https://rs.jlcone.com/static/APP/app_version/jlcone-${version}.deb";
    hash = "sha256-Xnm7A14Inwd5rOr2Z9DvNOgZuadZlnmXgafl9qjPDIs=";
    # Upstream CDN has been seen rejecting curl's default User-Agent
    curlOptsList = [ "-A" "Mozilla/5.0" ];
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libnotify
    libsecret
    libuuid
    libxcb
    libxkbcommon
    nspr
    nss
    pango
    systemd
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxscrnsaver
    libxtst
  ];

  runtimeDependencies = with pkgs; [
    (lib.getLib systemd)
    libglvnd
    libnotify
    libappindicator-gtk3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -a opt/JLCONE $out/share/jlcone
    cp -a usr/share/applications usr/share/icons $out/share/

    substituteInPlace $out/share/applications/jlcone.desktop \
      --replace-fail "Exec=/opt/JLCONE/jlcone" "Exec=jlcone"

    makeWrapper $out/share/jlcone/jlcone $out/bin/jlcone \
      --prefix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.libglvnd ]} \
      --add-flags "--ozone-platform-hint=auto" \
      --add-flags "--enable-wayland-ime=true" \
      --add-flags "--password-store=gnome-libsecret"

    runHook postInstall
  '';

  meta = with lib; {
    description = "JLCONE - JLCPCB desktop client";
    homepage = "https://jlcone.com";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "jlcone";
  };
}
