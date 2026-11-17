{
  lib,
  stdenv,
  src,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "limepcie";
  version = "0.1.12-${kernel.version}";

  inherit src;
  sourceRoot = "${src.name}/drivers/linux/limepcie";

  __structuredAttrs = true;
  strictDeps = true;

  hardeningDisable = [
    "format"
    "pic"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # strncpy is gone from the kernel; the length is already bounded and the
  # string is terminated right after, so a plain memcpy does the same thing
  postPatch = ''
    substituteInPlace limepcie_core.c \
      --replace-fail "strncpy(destination, identifier, size);" "memcpy(destination, identifier, size);"
  '';

  # upstream generates the Kbuild file and version.h through cmake, which wants
  # the running kernel; recreate them here instead (see cmake/add_kernel_module.cmake)
  preBuild = ''
    makeFlags+=("M=$PWD")

    cat > Kbuild <<EOF
    ccflags-y += -Wno-declaration-after-statement
    ccflags-y += -std=gnu11
    obj-m = limepcie.o
    limepcie-y := limepcie_core.o limeuart.o
    EOF

    cat > version.h <<EOF
    #ifndef LIMEPCIE_MODULE_VERSION_H
    #define LIMEPCIE_MODULE_VERSION_H
    #define LIMEPCIE_VERSION "$(cat VERSION)"
    #define LIMEPCIE_GIT_HASH "${builtins.substring 0 8 src.rev}"
    #endif
    EOF
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KERNELRELEASE=${kernel.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  # modules_install signs through kmodigest (cmd_sign in kernelModuleMakeFlags)
  installFlags = [
    "DEPMOD=true"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
  installTargets = [ "modules_install" ];

  meta = {
    description = "Linux kernel module for LimeSDR PCIe devices (X3, XTRX, X8)";
    homepage = "https://github.com/myriadrf/LimeSuiteNG";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
