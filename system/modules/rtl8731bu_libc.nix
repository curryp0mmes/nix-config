{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}: 

stdenv.mkDerivation rec {
  pname = "rtl8731bu-libc";
  version = "unstable-2026-02-02";

  src = fetchFromGitHub {
    owner = "libc0607";
    repo = "rtl8733bu-20230626";
    rev = "v5.13.0.1"; # or pin to latest commit
    sha256 = "sha256-eU0Qvv4/TwKaFRRQuDssAiN6n1F7W+IIOMS3U14g/k4=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ]
  ++ kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"

    
    echo 'EXTRA_CFLAGS += -I$(PWD)' >> Makefile
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;
}
