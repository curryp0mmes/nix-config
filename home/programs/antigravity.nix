{
  pkgs,
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  ...
}:

stdenv.mkDerivation rec {
  pname = "antigravity";
  version = "2.3.1-5358163105546240";

  src = fetchurl {
    url = "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.3.1-5358163105546240/linux-x64/Antigravity.tar.gz";
    hash = "sha256-ehmSFJ45bswS56QrFVY4lYcB2qplvtB83P5jm4Jnx0U=";
  };

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
