{ pkgs ? import <nixpkgs> {} }:

let
miseLibs = pkgs.symlinkJoin {
  name = "mise-build-libs";
  paths = with pkgs; [
    bison
    bzip2.dev
    bzip2.out
    curl.bin
    curl.dev
    curl.out
    fontconfig.dev
    fontconfig.lib
    fontconfig.out
    freetype.dev
    freetype.out
    gd.bin
    gd.dev
    gd.out
    gdbm.dev
    gdbm.out
    gdbm.lib
    icu.dev
    icu.out
    gmp.out
    gmp.dev
    libffi.dev
    libffi.out
    libiconv
    libuuid.bin
    libuuid.dev
    libuuid.out
    libx11.dev
    libx11.out
    libyaml.dev
    libyaml.out
    libxml2.bin
    libxml2.dev
    libxml2.out
    mpdecimal.dev
    mpdecimal.out
    ncurses.dev
    ncurses.out
    openssl.bin
    openssl.dev
    re2c
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
  buildInputs = [
    miseLibs
    pkgs.gettext
    pkgs.glfw
    pkgs.libGLU
    pkgs.unixODBC
  ];
  nativeBuildInputs = [
    miseLibs
    pkgs.gdbm
    pkgs.tcl
    pkgs.tk
  ];
  shellHook = ''
    export PATH="${miseLibs}/bin:$PATH"
    export CFLAGS="-O2 -g -I${miseLibs}/include"
    export CPPFLAGS="-I${miseLibs}/include"
    export LDFLAGS="-L${miseLibs}/lib"
    export LD_LIBRARY_PATH="${miseLibs}/lib"
    export PKG_CONFIG_PATH="${miseLibs}/lib/pkgconfig"
    export KERL_CONFIGURE_OPTIONS="--enable-wx --enable-webview --with-ssl=${miseLibs} --with-odbc=${pkgs.unixODBC}"
    export PHP_CONFIGURE_OPTIONS="--with-gettext=${pkgs.gettext}"
  '';
}
