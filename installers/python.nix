{ pkgs ? import <nixpkgs> {} }:

let
pythonLibs = pkgs.symlinkJoin {
  name = "python-build-libs";
  paths = with pkgs; [
    zlib.dev
    zlib.out
    readline.out
    readline.dev
    # bzip2.bin
    bzip2.dev
    bzip2.out
    # sqlite.bin
    sqlite.dev
    sqlite.out
    openssl.bin
    openssl.dev
    openssl.out
    ncurses.dev
    ncurses.out
    libffi.dev
    libffi.out
    xz.dev
    xz.out
    tcl
    tk.dev
    tk.out
  ];
};
in
  pkgs.mkShell {
  buildInputs = [ pythonLibs ];
  shellHook = ''
    export PATH="${pythonLibs}/bin:$PATH"
    export CFLAGS="-I${pythonLibs}/include"
    export CPPFLAGS="-I${pythonLibs}/include"
    export LDFLAGS="-L${pythonLibs}/lib"
    export PKG_CONFIG_PATH="${pythonLibs}/lib/pkgconfig"
    export TCLTK_LIBS="-L${pythonLibs}/lib -ltcl8.6 -ltk8.6"
    export TCLTK_CFLAGS="-I${pythonLibs}/include"
    export PYTHON_CONFIGURE_OPTS="--with-openssl=${pythonLibs}"
    echo $LDFLAGS
    echo $PYTHON_CONFIGURE_OPTS
  '';
}
