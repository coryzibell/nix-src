{ pkgs ? import <nixpkgs> {} }:

let
pythonLibs = pkgs.symlinkJoin {
  name = "python-build-libs";
  paths = with pkgs; [
    zlib.dev
    zlib.out
    readline.out
    readline.dev
    mpdecimal.out
    mpdecimal.dev
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
    tk-8_6
    tk-8_6.dev
    tk-8_6.out
    libuuid.bin
    libuuid.dev
    libuuid.out
    libx11.dev
    libx11.out
    xorg.libXft.dev
    xorg.libXft.out
    freetype.out
    freetype.dev
    fontconfig.dev
    fontconfig.lib
    fontconfig.out
  ];
};
in
  pkgs.mkShell {
  buildInputs = [ pythonLibs ];
  shellHook = ''
    export PATH="${pythonLibs}/bin:$PATH"
    export CFLAGS="-I${pythonLibs}/include"
    export PYTHON_CFLAGS="-I${pythonLibs}/include"
    export CPPFLAGS="-I${pythonLibs}/include"
    export LDFLAGS="-L${pythonLibs}/lib -ltcl8.6 -ltclstub8.6"
    export LD_LIBRARY_PATH="${pythonLibs}/lib"
    export PKG_CONFIG_PATH="${pythonLibs}/lib/pkgconfig"
    # export TCLTK_LIBS="-L${pythonLibs}/lib -ltcl8.6 -ltk8.6"
    # export TCLTK_CFLAGS="-I${pythonLibs}/include"
    export PYTHON_CONFIGURE_OPTS="--with-openssl=${pythonLibs}"
    cat "${pythonLibs}/lib/pkgconfig/tk.pc"
  '';
}
