{
  pkgs,
  stdenv,
  lib,
  makeWrapper,
  ...
}:

stdenv.mkDerivation rec {
  pname = "antigravity";
  version = "1.0.0"; # Version not explicitly found, using 1.0.0

  src = ./Antigravity.tar.gz;

  nativeBuildInputs = with pkgs; [
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
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libglvnd
    libnotify
    libsecret
    libuuid
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxshmfence
    libxkbfile
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/antigravity
    cp -av . $out/share/antigravity/

    ln -s $out/share/antigravity/antigravity $out/bin/antigravity

    runHook postInstall
  '';

  postFixup = ''
    # Remove LD_LIBRARY_PATH to avoid poisoning other apps via xdg-open
    wrapProgram $out/bin/antigravity \
      --add-flags "--no-sandbox" \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform=wayland" \
      --add-flags "--password-store=gnome-libsecret" \
      --set XDG_CURRENT_DESKTOP "niri"
  '';

  meta = with lib; {
    description = "Official Antigravity Suite from Google";
    homepage = "https://google.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
