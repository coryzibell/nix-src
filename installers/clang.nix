{ pkgs ? import <nixpkgs> {} }:

let
opensslCombined = pkgs.symlinkJoin {
  name = "openssl-combined";
  paths = with pkgs; [
    openssl.bin
    openssl.dev
    openssl.out
  ];
};
zlibCombined = pkgs.symlinkJoin {
  name = "zlib-combined";
  paths = with pkgs; [
    zlib.dev
    zlib.out
  ];
};
libxml2Combined = pkgs.symlinkJoin {
  name = "libxml2-combined";
  paths = with pkgs; [
    libxml2.bin
    libxml2.dev
    libxml2.out
  ];
};
backtraceCombined = pkgs.libbacktrace;
libeditCombined = pkgs.symlinkJoin {
  name = "libedit-combined";
  paths = with pkgs; [
    libedit.dev
    libedit.out
  ];
};
in
  pkgs.mkShell {
  buildInputs = [ opensslCombined zlibCombined libxml2Combined backtraceCombined libeditCombined ];
  shellHook = ''
    export ZLIB_ROOT="${zlibCombined}"
    export ZLIB_LIBRARY="${zlibCombined}/lib/libz.so"
    export ZLIB_INCLUDE_DIR="${zlibCombined}/include"
    export OPENSSL_ROOT="${opensslCombined}"
    export OPENSSL_LIBRARIES="${opensslCombined}/lib"
    export OPENSSL_INCLUDE_DIR="${opensslCombined}/include"
    export LIBXML2_ROOT="${libxml2Combined}"
    export LIBXML2_LIBRARIES="${libxml2Combined}/lib"
    export LIBXML2_INCLUDE_DIR="${libxml2Combined}/include"
    export Backtrace_ROOT="${backtraceCombined}"
    export Backtrace_LIBRARIES="${backtraceCombined}/lib"
    export Backtrace_INCLUDE_DIR="${backtraceCombined}/include"
    export LIBEDIT_ROOT="${libeditCombined}"
    export LIBEDIT_LIBRARIES="${libeditCombined}/lib"
    export LIBEDIT_INCLUDE_DIR="${libeditCombined}/include"
    echo ${zlibCombined}
    echo ${opensslCombined}
    echo ${libxml2Combined}
    echo ${backtraceCombined}
    echo ${libeditCombined}
  '';
}
