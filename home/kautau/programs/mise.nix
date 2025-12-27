{ pkgs, mise, ... }:

{
  enable = true;
  package = mise.packages.${pkgs.stdenv.hostPlatform.system}.default;
  enableBashIntegration = true;
  enableZshIntegration = true;
  enableNushellIntegration = true;

  globalConfig = {
    settings = {
      all_compile = false;
      exec_auto_install = false;
      jobs = 1;
      # verbose = true;
    };

    tools = {
      node = "latest";
      "cargo:ascim" = "latest";
      "cargo:base-d" = "latest";
      "cargo:bottom" = "latest";
      "cargo:cargo-outdated" = "latest";
      "cargo:eza" = "latest";
      "cargo:mx" = "latest";
      "cargo:gifclip" = "latest";
      "cargo:speedo" = "latest";
      "cargo:tealdeer" = "latest";
      "npm:npm" = "latest";
      "npm:corepack" = "latest";
      "npm:@anthropic-ai/claude-code" = "latest";
      "npm:@github/copilot" = "latest";
      "npm:@google/gemini-cli" = "latest";
      "npm:@quasar/cli" = "latest";
      "npm:cordova" = "latest";
      "npm:tweakcc" = "latest";
      cargo-binstall = "latest";
      bun = "latest";
      deno = "latest";
      elixir = "latest";
      erlang = "latest";
      ghc = "latest";
      cabal = "latest";
      stack = "latest";
      hls = "latest";
      go = "latest";
      java = "oracle-graalvm";
      flutter = "latest";
      php = "latest";
      python = "latest";
      ruby = "latest";
      rust = "latest";
      zig = "latest";
    };
  };
}
