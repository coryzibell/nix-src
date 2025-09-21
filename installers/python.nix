{ pkgs ? import <nixpkgs> {} }:

let
pythonLibs = pkgs.symlinkJoin {
  name = "python-build-libs";
  paths = with pkgs; [
    bzip2.dev
    bzip2.out
    fontconfig.dev
    fontconfig.lib
    fontconfig.out
    freetype.dev
    freetype.out
    gdbm.dev
    gdbm.out
    gdbm.lib
    libffi.dev
    libffi.out
    libuuid.bin
    libuuid.dev
    libuuid.out
    libx11.dev
    libx11.out
    mpdecimal.dev
    mpdecimal.out
    ncurses.dev
    ncurses.out
    openssl.bin
    openssl.dev
    openssl.out
    readline.dev
    readline.out
    sqlite.dev
    sqlite.out
    tcl
    tk
    tk.dev
    tk.out
    xorg.libXft.dev
    xorg.libXft.out
    xorg.libXinerama.dev
    xorg.libXinerama.out
    xz.dev
    xz.out
    zlib.dev
    zlib.out
  ];
};
in
  pkgs.mkShell {
  buildInputs = [ pythonLibs ];
  nativeBuildInputs = [
    pythonLibs
    pkgs.gdbm
    pkgs.tcl
    pkgs.tk
  ];
  shellHook = ''
    export PATH="${pythonLibs}/bin:$PATH"
    export CFLAGS="-I${pythonLibs}/include"
    export PYTHON_CFLAGS="-I${pythonLibs}/include"
    export CPPFLAGS="-I${pythonLibs}/include"
    export LDFLAGS="-L${pythonLibs}/lib"
    export LD_LIBRARY_PATH="${pythonLibs}/lib"
    export PKG_CONFIG_PATH="${pythonLibs}/lib/pkgconfig"
    # export TCLTK_LIBS="-L${pythonLibs}/lib -ltcl8.6 -ltk8.6"
    # export TCLTK_CFLAGS="-I${pythonLibs}/include"
    export PYTHON_CONFIGURE_OPTS="--with-openssl=${pythonLibs}"
  '';
}
