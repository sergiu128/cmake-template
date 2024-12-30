let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
  packages = with pkgs; [
    gnumake
    zlib
    clang-tools_19
    clang_19
    llvm_19
    lld_19
    cmake
    ninja
    jre
  ];

  shellHook = ''
    export CXX=clang++
    export CC=clang
    export LIB_BUILD_PREFIX=$(pwd)/deps_build
    export LIB_INSTALL_PREFIX=$(pwd)/deps_install
    export USES_NIX=1
    export CMAKE_GENERATOR=Ninja
  '';
}

