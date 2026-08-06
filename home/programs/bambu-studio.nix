{ appimageTools, fetchurl, lib, makeDesktopItem, cacert, glibcLocales }:

let
  pname = "bambu-studio";
  version = "02.07.01.62";

  src = fetchurl {
    url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/BambuStudio_ubuntu24.04-v${version}-20260616195227.AppImage";
    hash = "sha256-+pi2CFMt+7uysJMUg6rEHlf7GcF1osx719Uo1eD7soc=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  desktopItem = makeDesktopItem {
    name = "bambu-studio";
    exec = "bambu-studio";
    icon = "bambu-studio";
    comment = "PC Software for BambuLab's 3D printers";
    desktopName = "Bambu Studio";
    genericName = "3D Slicer";
    categories = [ "Utility" "3DGraphics" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libsecret
    webkitgtk_4_1
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    udev
    gdk-pixbuf
    librsvg
    libdbusmenu-gtk3
    libX11
    libXi
    libXext
    libXrender
    libXrandr
    libXcursor
    libXinerama
    libXfixes
  ];

  profile = ''
    export GDK_BACKEND=x11
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    export CURL_CA_BUNDLE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    export WEBKIT_DISABLE_DMABUF_RENDERER=1

    # Force supported UTF-8 locale inside FHS container to prevent missing en_GB locale error
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export LANGUAGE="en_US:en"

    # Provide all locales inside the FHS container
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '';

  extraInstallCommands = ''
    # Install desktop item
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    # Install icon
    install -m 444 -D ${appimageContents}/BambuStudio.png $out/share/icons/hicolor/128x128/apps/bambu-studio.png
  '';

  meta = with lib; {
    description = "PC Software for BambuLab's 3D printers (AppImage Wrapper)";
    homepage = "https://github.com/bambulab/BambuStudio";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
