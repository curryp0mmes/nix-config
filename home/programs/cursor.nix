{
  pkgs,
  stdenv,
  lib,
  makeWrapper,
  ...
}:

stdenv.mkDerivation rec {
  pname = "cursor3";
  version = "3.0.16";

  src = ./cursor_3.0.16_amd64.deb;

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    makeWrapper # Needed to wrap the binary for Wayland/Sandbox
  ];

  # Electron apps are heavy on dependencies.
  # You'll likely need these for Cursor to launch.
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

  unpackPhase = ''
    runHook preUnpack
    ar x $src
    tar xf data.tar.xz --no-same-owner --no-same-permissions
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/cursor3

    # 1. Defensive Copy:
    # Instead of globbing opt/*/*, copy the whole opt/ content if it exists.
    if [ -d "opt" ]; then
      cp -av opt/. $out/share/cursor3/
    elif [ -d "usr/share" ]; then
      cp -av usr/share/. $out/share/cursor3/
    fi

    # 2. Binary Discovery:
    # We look for the main 'cursor' executable within the newly copied share directory.
    # We ignore the 'resources' folder to avoid picking up helper binaries.
    BIN_PATH=$(find $out/share/cursor3 -name cursor -type f -executable -not -path "*resources*" | head -n 1)

    if [ -z "$BIN_PATH" ]; then
      echo "ERROR: Could not find the 'cursor' binary in the extracted files."
      # Let's list what we have to help debug if it fails again
      find $out/share/cursor3 -maxdepth 3
      exit 1
    fi

    ln -s "$BIN_PATH" $out/bin/cursor3

    runHook postInstall
  '';

  postFixup = ''
    # We remove LD_LIBRARY_PATH to avoid poisoning Firefox/Chrome 
    # when the app calls xdg-open.
    wrapProgram $out/bin/cursor3 \
      --add-flags "--no-sandbox" \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform=wayland" \
      --add-flags "--password-store=gnome-libsecret" \
      --set XDG_CURRENT_DESKTOP "niri"
  '';

  meta = with lib; {
    description = "AI-powered code editor (Cursor 3)";
    homepage = "https://cursor.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
