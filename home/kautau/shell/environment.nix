{ pkgs, ... }:

let
  devLibs = import ../packages/dev-libs.nix { inherit pkgs; };
in
{
  EDITOR = "hx";
  MISE_NODE_COREPACK = "true";

  # Build flags
  CFLAGS = "-O2 -g -I${devLibs}/include";
  CXXFLAGS = "-O2 -g -I${devLibs}/include";
  PYTHON_CFLAGS = "-I${devLibs}/include";
  CPPFLAGS = "-I${devLibs}/include";
  LDFLAGS = "-L${devLibs}/lib";
  LD_LIBRARY_PATH = "${devLibs}/lib:${pkgs.stdenv.cc.cc.lib}/lib";
  PKG_CONFIG_PATH = "${devLibs}/lib/pkgconfig:${devLibs}/share/pkgconfig";

  # Nix build environment
  NIX_CFLAGS_COMPILE = "-I${devLibs}/include";
  NIX_LDFLAGS = "-L${devLibs}/lib";

  # CMake configuration
  CMAKE_PREFIX_PATH = "${devLibs}";
  CMAKE_INCLUDE_PATH = "${devLibs}/include";
  CMAKE_LIBRARY_PATH = "${devLibs}/lib";

  # Python/mise configuration
  PYTHON_CONFIGURE_OPTS = "--with-openssl=${devLibs}";

  # Erlang/Elixir configuration
  KERL_CONFIGURE_OPTIONS = "--enable-wx --enable-webview --with-ssl=${devLibs} --with-odbc=${devLibs}";

  # PHP configuration
  PHP_CONFIGURE_OPTIONS = "--with-openssl=${devLibs} --with-curl=${devLibs} --with-gettext=${devLibs} --with-sodium=${devLibs}";

  # Ruby configuration (skip test extensions to avoid NixOS glibc compatibility issues)
  RUBY_CONFIGURE_OPTS = "--disable-install-doc --with-out-ext=-test-/cxxanyargs";

  # Clang/LLVM library paths
  ZLIB_ROOT = "${devLibs}";
  ZLIB_LIBRARY = "${devLibs}/lib/libz.so";
  ZLIB_INCLUDE_DIR = "${devLibs}/include";
  OPENSSL_ROOT = "${devLibs}";
  OPENSSL_LIBRARIES = "${devLibs}/lib";
  OPENSSL_INCLUDE_DIR = "${devLibs}/include";
  LIBXML2_ROOT = "${devLibs}";
  LIBXML2_LIBRARIES = "${devLibs}/lib";
  LIBXML2_INCLUDE_DIR = "${devLibs}/include";
  Backtrace_ROOT = "${pkgs.libbacktrace}";
  Backtrace_LIBRARIES = "${pkgs.libbacktrace}/lib";
  Backtrace_INCLUDE_DIR = "${pkgs.libbacktrace}/include";
  LIBEDIT_ROOT = "${devLibs}";
  LIBEDIT_LIBRARIES = "${devLibs}/lib";
  LIBEDIT_INCLUDE_DIR = "${devLibs}/include";

  # Rust linker configuration
  RUSTFLAGS = "-L ${devLibs}/lib -L ${pkgs.stdenv.cc.cc.lib}/lib -C link-arg=-Wl,-rpath,${devLibs}/lib -C link-arg=-Wl,-rpath,${pkgs.stdenv.cc.cc.lib}/lib";
}
