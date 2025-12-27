{ pkgs, ... }:

# Combined development libraries for mise and general development
pkgs.symlinkJoin {
  name = "dev-libs";
  paths = with pkgs; [
    # === Core System Libraries ===
    dbus.dev
    dbus.lib
    dbus.out
    glibc.bin
    glibc.dev
    glibc.out
    glibc.static
    libbacktrace
    libiconv
    libuuid.bin
    libuuid.dev
    libuuid.out

    # === Compression Libraries ===
    brotli.dev
    brotli.lib
    brotli.out
    bzip2.dev
    bzip2.out
    libdeflate
    libzip.dev
    libzip.out
    xz.dev
    xz.out
    zlib.dev
    zlib.out
    zstd.bin
    zstd.dev
    zstd.out

    # === Cryptography & Security ===
    libargon2
    libsodium.dev
    libsodium.out
    openssl.bin
    openssl.dev
    openssl.out

    # === SELinux Security ===
    libselinux.bin
    libselinux.dev
    libselinux.out
    libsepol.bin
    libsepol.dev
    libsepol.out

    # === Text Processing & Internationalization ===
    enchant2.dev
    enchant2.out
    expat.dev
    expat.out
    gettext
    icu.dev
    icu.out
    oniguruma.dev
    oniguruma.lib
    oniguruma.out
    pcre2.dev
    pcre2.out
    re2c

    # === Data Structures & Parsing ===
    gmp.dev
    gmp.out
    mpdecimal.dev
    mpdecimal.out
    libyaml.dev
    libyaml.out

    # === Databases ===
    gdbm.dev
    gdbm.lib
    gdbm.out
    mariadb
    postgresql.dev
    postgresql.lib
    postgresql.out
    sqlite.dev
    sqlite.out
    unixODBC

    # === LDAP ===
    openldap.dev
    openldap.out

    # === Networking & Transfer ===
    curl.bin
    curl.dev
    curl.out

    # === Terminal & CLI ===
    libedit.dev
    libedit.out
    ncurses.dev
    ncurses.out
    ncurses5
    readline.dev
    readline.out

    # === Build Tools & FFI ===
    bison
    libffi.dev
    libffi.out

    # === Graphics & OpenGL ===
    glfw
    libGL.dev
    libGL.out
    libGLU
    libGLU.dev
    libGLU.out
    libepoxy.dev
    libepoxy.out
    libglvnd.dev
    libglvnd.out
    mesa.out

    # === Image Processing & Formats ===
    imagemagick.dev
    imagemagick.out
    lerc.dev
    lerc.out
    libavif.dev
    libavif.out
    libjpeg.bin
    libjpeg.dev
    libjpeg.out
    libpng.dev
    libpng.out
    libtiff.bin
    libtiff.dev
    libtiff.out
    libwebp

    # === Font & Text Rendering ===
    fontconfig.dev
    fontconfig.lib
    fontconfig.out
    freetype.dev
    freetype.out
    fribidi.dev
    fribidi.out
    graphite2.dev
    graphite2.out
    harfbuzz.dev
    harfbuzz.out
    pango.dev
    pango.out

    # === GTK & GUI Libraries ===
    atk.dev
    atk.out
    cairo.dev
    cairo.out
    gdk-pixbuf.dev
    gdk-pixbuf.out
    glib.dev
    glib.out
    gtk3.dev
    gtk3.out
    libsysprof-capture
    sysprof.dev
    sysprof.lib
    sysprof.out

    # === Graphics Utilities ===
    gd.bin
    gd.dev
    gd.out
    pixman

    # === Thai Language Support ===
    libdatrie.bin
    libdatrie.dev
    libdatrie.lib
    libdatrie.out
    libthai.dev
    libthai.out

    # === X11 & Wayland Display ===
    libx11.dev
    libx11.out
    libxkbcommon.dev
    libxkbcommon.out
    libxrandr.dev
    libxrandr.out
    libxcomposite.dev
    libxcomposite.out
    libxcursor.dev
    libxcursor.out
    libxdamage.dev
    libxdamage.out
    libxtst
    wayland.dev
    wayland.out
    wayland-protocols
    xorg.libXau.dev
    xorg.libXau.out
    xorg.libXdmcp.dev
    xorg.libXdmcp.out
    xorg.libXext.dev
    xorg.libXext.out
    xorg.libXft.dev
    xorg.libXft.out
    xorg.libXfixes.dev
    xorg.libXfixes.out
    xorg.libXi.dev
    xorg.libXi.out
    xorg.libXinerama.dev
    xorg.libXinerama.out
    xorg.libXrender.dev
    xorg.libXrender.out
    xorg.libxcb.dev
    xorg.libxcb.out
    xorg.xorgproto

    # === Tcl/Tk GUI Framework ===
    tcl
    tk
    tk.dev
    tk.out

    # === XML & XSLT Processing ===
    html-tidy
    libxml2.bin
    libxml2.dev
    libxml2.out
    libxslt.bin
    libxslt.dev
    libxslt.out

    # === PHP Extensions ===
    php84Extensions.igbinary.dev
    php84Extensions.igbinary.out
  ];
}
