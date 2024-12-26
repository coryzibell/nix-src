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
odbcOut = pkgs.unixODBC;
in
  pkgs.mkShell {
  buildInputs = [ opensslCombined pkgs.ncurses5 pkgs.glfw pkgs.libGLU odbcOut ];
  shellHook = ''
    export KERL_CONFIGURE_OPTIONS="--enable-wx --enable-webview --with-ssl=${opensslCombined} --with-odbc=${odbcOut}"
  '';
}
