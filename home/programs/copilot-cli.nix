{
  lib,
  stdenv,
  autoPatchelfHook,
  cacert,
  fetchurl,
  glib,
  libsecret,
  makeWrapper,
  bash,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:
let
  sources = {
    "x86_64-linux" = {
      suffix = "linux-x64";
      sha256 = "cfbd116fe159be289abadf2c2bf18a25a8ab09eeca54a091d4025e1cbcda4709";
    };
    "aarch64-linux" = {
      suffix = "linux-arm64";
      sha256 = "b1a2076cb3a587eba2bc6f478ce35e53f20a34d0d69b41807439b3302df5f75a";
    };
    "x86_64-darwin" = {
      suffix = "darwin-x64";
      sha256 = "6e22123b6b175fe1d6786a3ee2f5d1bb733d04df37f6c14137431c01c3c158d2";
    };
    "aarch64-darwin" = {
      suffix = "darwin-arm64";
      sha256 = "4ebfa2b31154996420417de2be0949ef1f4e35af0943d65515474d5ae3c22b11";
    };
  };

  sys = stdenv.hostPlatform.system;
  srcInfo = sources.${sys} or (throw "Unsupported system: ${sys}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "github-copilot-cli";
  version = "1.0.70";

  # Use the platform-specific package, which contains the pre-bundled JS files and native builds
  src = fetchurl {
    url = "https://github.com/github/copilot-cli/releases/download/v${finalAttrs.version}/github-copilot-${finalAttrs.version}-${srcInfo.suffix}.tgz";
    inherit (srcInfo) sha256;
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    glib
    libsecret
  ];
  sourceRoot = "package";
  dontStrip = true;
  # computer.node requires GUI/media libraries (X11, pipewire, libei, libjpeg,
  # libpng) for screen-capture and input-simulation features that are not
  # relevant for CLI use; ignore those missing deps rather than fail the build
  # or pull in heavy dependencies.
  autoPatchelfIgnoreMissingDeps = [
    "libX11.so.6"
    "libXtst.so.6"
    "libjpeg.so.8"
    "libpng16.so.16"
    "libpipewire-0.3.so.0"
    "libei.so.1"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/lib/github-copilot-cli
    cp -r * "$out"/lib/github-copilot-cli
    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${nodejs}/bin/node "$out"/bin/copilot \
      --add-flag "$out"/lib/github-copilot-cli/index.js \
      --add-flag --no-auto-update \
      --set-default NODE_NO_WARNINGS 1 \
      --set-default SSL_CERT_DIR ${cacert}/etc/ssl/certs \
      --prefix PATH : "${lib.makeBinPath [ bash ]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  # TODO are these errors still present after moving to using the "universal"
  # package?
  doInstallCheck = !stdenv.hostPlatform.isDarwin; # skip on Darwin - OpenSSL errors in sandbox

  # Looks like GitHub use tags for both pre-release and actually released
  # versions, but only the actual versions will be available as a GitHub
  # release, so use the release endpoint rather than nix-update-script`'s
  # default of looking for tags.
  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal";
    homepage = "https://github.com/github/copilot-cli";
    changelog = "https://github.com/github/copilot-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      me-and
    ];
    mainProgram = "copilot";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
