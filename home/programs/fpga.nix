# FPGA / digital design tooling — the nixpkgs-packaged subset of YosysHQ's
# oss-cad-suite. Python libraries (amaranth, migen, cocotb) are left to
# per-project flakes/devshells.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ### RTL synthesis
    (yosys.withPlugins (with yosys.allPlugins; [ ghdl ]))
    abc-verifier
    ghdl
    sv-lang # slang

    ### Formal
    sby
    mcy
    aiger
    avy
    boolector
    yices
    z3
    bitwuzla

    ### Place and route / bitstream tools
    nextpnr
    icestorm
    trellis
    prjoxide
    python3Packages.apycula
    prjpeppercorn

    ### Board programming
    openfpgaloader
    dfu-util
    ecpdap
    fujprog
    openocd

    ### Simulation / waveforms
    gtkwave
    surfer
    verilator
    iverilog

    ### Diagrams
    netlistsvg
    svgo
  ];
}
