# Skykeep (iCloud Notes/Reminders/Calendar/Contacts/Drive/Photos) packaged from the
# upstream release .deb — same approach as the AUR `skykeep-bin` package.
# To update: bump `version`, then set `hash = lib.fakeHash;`, rebuild, and paste the hash
# Nix prints in the error.
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  glib,
  glib-networking,
  gtk3,
  cairo,
  gdk-pixbuf,
  dbus,
  libsoup_3,
  webkitgtk_4_1,
  libheif,
  libsecret,
  libayatana-appindicator,
  pipewire,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "skykeep";
  version = "0.1.42";

  src = fetchurl {
    url = "https://github.com/YashwanthKamireddi/Skykeep/releases/download/v${version}/Skykeep-linux-amd64.deb";
    hash = "sha256-7Q4/h//oxZdGuGdSzTvKjULB9pCE/nd3J7CKIHvc7hU=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    stdenv.cc.cc.lib # libgcc_s
    glib
    glib-networking # TLS for WebKit
    gtk3
    cairo
    gdk-pixbuf
    dbus
    libsoup_3
    webkitgtk_4_1
    libheif
    libsecret
    libayatana-appindicator
    pipewire
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  # Loaded with dlopen at runtime (keyring + tray icon), so autoPatchelf can't see them.
  runtimeDependencies = [
    libsecret
    libayatana-appindicator
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out/
    chmod 755 $out/bin/skykeep

    # Unused 2x icon folder no icon theme reads.
    rm -rf $out/share/icons/hicolor/*@2

    # The webcam helper is hard-coded to /usr/lib/skykeep and writes into /etc, which
    # can't work on NixOS. The webcam is configured declaratively instead (see README).
    rm -rf $out/lib/skykeep $out/share/polkit-1

    substituteInPlace $out/share/dbus-1/services/*.service \
      --replace-fail /usr/bin/skykeep $out/bin/skykeep

    runHook postInstall
  '';

  meta = {
    description = "iCloud Notes, Reminders, Calendar, Contacts, Drive and Photos as native apps";
    homepage = "https://github.com/YashwanthKamireddi/Skykeep";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "skykeep";
  };
}
