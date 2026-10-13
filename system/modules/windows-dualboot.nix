{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  esp = config.boot.loader.efi.efiSysMountPoint;
  lzbt = inputs.lanzaboote.packages.${pkgs.stdenv.hostPlatform.system}.lzbt;
in
{
  # Requires ./secure-boot.nix (lanzaboote).
  #
  # Windows Boot Manager lives on the same ESP. systemd-boot's auto-detected
  # entry has no sort-key, so it always ends up below every NixOS generation.
  # Instead write our own entry that sorts directly below the newest generation:
  # entries are ordered by sort-key, then version (descending), and "~" sorts lower
  # than anything else, so "Generation <newest>~windows" lands between
  # "Generation <newest>, ..." and "Generation <newest - 1>, ...".
  #
  # Lanzaboote has no post-install hook, so wrap lzbt to write the entry after every install.
  boot.lanzaboote.package = pkgs.writeShellScriptBin "lzbt" ''
    set -euo pipefail
    ${lib.getExe lzbt} "$@"

    export PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnused
      ]
    }:$PATH
    entries=${esp}/loader/entries
    mkdir -p "$entries"
    # leftovers from the plain systemd-boot installer, their kernels are gone
    rm -f "$entries"/nixos-*.conf

    newest=$(ls /nix/var/nix/profiles | sed -n 's/^system-\([0-9]*\)-link$/\1/p' | sort -n | tail -n1)
    cat > "$entries/windows.conf" <<EOF
    title Windows
    version Generation $newest~windows
    efi /EFI/Microsoft/Boot/bootmgfw.efi
    sort-key ${config.boot.lanzaboote.sortKey}
    EOF
  '';

  # hide the auto-detected duplicate
  boot.lanzaboote.settings.auto-entries = false;
}
